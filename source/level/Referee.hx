package level;

import bus.*;
import domain.*;
import timing.BeatEvent;

class Referee {
    private var universalBus : UniversalBus;
    private var unsafeSquares : UnsafeSquareKiller;
    private var bpm : Int;
    private var logicalPlayerPosition : Displacement;
    private var crates : Array<Displacement>;
    private var healthPickups : Array<Displacement>;
    private var isTutorial : Bool;

    public function new(universalBus : UniversalBus, bpm : Int) {
        this.universalBus = universalBus;
        universalBus.newControlDesire.subscribe(this, handleNewControlDesire);
        universalBus.crateLanded.subscribe(this, handleCrateLanded);
        universalBus.crateDestroyed.subscribe(this, handleCrateDestroyed);
        universalBus.threatKillSquare.subscribe(this, handleThreatKillingSquare);
        universalBus.triggerBeats.subscribe(this, handleTriggerBeats);
        universalBus.playerStartMove.subscribe(this, handlePlayerMove);
        universalBus.playerHit.subscribe(this, handlePlayerHit);
        universalBus.healthLanded.subscribe(this, function(x) {
            if (logicalPlayerPosition.equals(x)) {
                universalBus.healthHit.broadcast(x);
                return;
            }
            for (healthPickup in healthPickups) {
                if (healthPickup.equals(x)) {
                    return;
                }
            }
            healthPickups.push(x);
        });
        universalBus.healthHit.subscribe(this, function(x) {
            healthPickups.remove(x);
        });

        unsafeSquares = new UnsafeSquareKiller(universalBus, bpm);
        this.bpm = bpm;

        logicalPlayerPosition = new Displacement(NONE, NONE);
        crates = [];

        healthPickups = [];

        isTutorial = false;
        universalBus.tutorialFlag.subscribe(this, function(_) {
            isTutorial = true;
        });
    }

    public function handleNewControlDesire(displacement : Displacement) {
        // the location halfway between player and destination
        var halfLocation : Displacement = null;
        if (Displacement.opposeVertically(displacement, logicalPlayerPosition)) {
            // crate and player opposing each other in a column
            halfLocation = new Displacement(displacement.horizontalDisplacement, NONE);
        } else if (Displacement.opposeHorizontally(displacement, logicalPlayerPosition)) {
            // crate and player opposing each other in a row
            halfLocation = new Displacement(NONE, displacement.verticalDisplacement);
        } else if (Displacement.opposeDiagonally(displacement, logicalPlayerPosition) ||
            Displacement.opposeInL(displacement, logicalPlayerPosition)) {
            // crate and player opposing each other on a diagonal
            halfLocation = new Displacement(NONE, NONE);
        }

        if (halfLocation != null) {
            for (crate in crates) {
                if (crate.equals(halfLocation)) {
                    if (!isTutorial) {
                        universalBus.crateHit.broadcast(crate);
                    }
                    return;
                }
            }
            for (healthPickup in healthPickups) {
                if (healthPickup.equals(halfLocation)) {
                    universalBus.healthHit.broadcast(healthPickup);
                }
            }
            universalBus.controls.broadcast(halfLocation);
        }
        for (crate in crates) {
            if (crate.equals(displacement)) {
                if (!isTutorial) {
                    universalBus.crateHit.broadcast(crate);
                }
                return;
            }
        }
        for (healthPickup in healthPickups) {
            if (healthPickup.equals(displacement)) {
                universalBus.healthHit.broadcast(healthPickup);
            }
        }

        // no crates in the way
        universalBus.controls.broadcast(displacement);
    }

    public function handleCrateLanded(displacement : Displacement) {
        crates.push(displacement);
    }

    public function handleCrateDestroyed(displacement : Displacement) {
        crates.remove(displacement);
    }

    public function handleThreatKillingSquare(event : ThreatLandedEvent) {
        unsafeSquares.add(event);
    }

    public function handlePlayerMove(displacement : Displacement) {
        logicalPlayerPosition = displacement;
    }

    public function handleTriggerBeats(beat : BeatEvent) {
        if (unsafeSquares.ready()) {
            unsafeSquares.finishAndWatch(logicalPlayerPosition, beat.beat);
            unsafeSquares = new UnsafeSquareKiller(universalBus, bpm);
        }
    }

    public function handlePlayerHit(event : ThreatLandedEvent) {
        trace("Player hit! : " + crates + "|" + event.position);
        for (crate in crates) {
            if (crate.equals(event.position)) {
                trace("Manually pushing player");
                universalBus.controls.broadcast(new Displacement(NONE, NONE));
            }
        }
    }
}

class UnsafeSquareKiller {
    public static var TOLERANCE_SECONDS(default, null) = 0.1;

    private var logicalPlayerPosition : Displacement;
    private var unsafeSquares : Array<ThreatLandedEvent>;
    private var playerStartedSafe : Bool;
    private var playerSafe : Bool;
    private var universalBus : UniversalBus;
    private var bpm : Int;
    private var nonEmpty : Bool;

    public function new(universalBus : UniversalBus, bpm : Int) {
        unsafeSquares = [];
        this.bpm = bpm;
        this.universalBus = universalBus;
        nonEmpty = false;
    }

    public function add(event : ThreatLandedEvent) {
        unsafeSquares.push(event);
        nonEmpty = true;
    }

    public function ready() {
        return nonEmpty;
    }

    /**
     *  This function watches the player to see if they move onto a safe square
     *  within the tolerance time. If they don't, then they are punished.
     *  
     *  @param currentPlayerPosition The player position at the beat
     *  @param beat The beat the threats hit
     */
    public function finishAndWatch(currentPlayerPosition : Displacement, beat : Float) {
        var targetBeat = beat + TOLERANCE_SECONDS / 60 * bpm;

        // If the player is safe when the threats hit, they'll always be safe!
        playerSafe = squareSafe(currentPlayerPosition);
        playerStartedSafe = playerSafe;
        logicalPlayerPosition = currentPlayerPosition;
        
        universalBus.playerStartMove.subscribe(this, playerMove); 
        universalBus.beat.subscribe(this, function(beatEvent : BeatEvent) {
            if (targetBeat > beatEvent.beat) {
                if (!playerSafe) {
                    for (unsafeSquare in unsafeSquares) {
                        if (unsafeSquare.position.equals(logicalPlayerPosition)) {
                            universalBus.playerHit.broadcast(unsafeSquare);
                        }
                    }
                }
                universalBus.playerStartMove.unsubscribe(this);
                universalBus.beat.unsubscribe(this);
            }
        });
    }

    public function playerMove(displacement : Displacement) {
        if (squareSafe(displacement)) {
            // player moved to a "safe" square - no threats here!
            playerSafe = true;
        }
        logicalPlayerPosition = displacement;
    }

    public function squareSafe(displacement : Displacement) {
        for (unsafeSquare in unsafeSquares) {
            if (unsafeSquare.position.equals(displacement)) {
                return false;
            }
        }

        return true;
    }
}
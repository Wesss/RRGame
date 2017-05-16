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

    public function new(universalBus : UniversalBus, bpm : Int) {
        this.universalBus = universalBus;
        universalBus.newControlDesire.subscribe(this, handleNewControlDesire);
        universalBus.crateLanded.subscribe(this, handleCrateLanded);
        universalBus.crateDestroyed.subscribe(this, handleCrateDestroyed);
        universalBus.threatKillSquare.subscribe(this, handleThreatKillingSquare);
        universalBus.triggerBeats.subscribe(this, handleTriggerBeats);
        universalBus.playerStartMove.subscribe(this, handlePlayerMove);

        unsafeSquares = new UnsafeSquareKiller(universalBus, bpm);
        this.bpm = bpm;

        crates = [];
    }

    public function handleNewControlDesire(displacement : Displacement) {
        for (crate in crates) {
            if (crate.equals(displacement)) {
                // a crate is where they want to be
                return;
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

    public function handleThreatKillingSquare(displacement : Displacement) {
        trace("Threat hit added");
        unsafeSquares.add(displacement);
    }

     public function handlePlayerMove(displacement : Displacement) {
        logicalPlayerPosition = displacement;
    }

    public function handleTriggerBeats(beat : BeatEvent) {
        if (unsafeSquares.ready()) {
            trace("Threats pushed to handler");
            unsafeSquares.finishAndWatch(logicalPlayerPosition, beat.beat);
            unsafeSquares = new UnsafeSquareKiller(universalBus, bpm);
        }
    }
}

class UnsafeSquareKiller {
    public static var TOLERANCE_SECONDS(default, null) = 0.1;

    private var logicalPlayerPosition : Displacement;
    private var unsafeSquares : Array<Displacement>;
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

    public function add(displacement : Displacement) {
        unsafeSquares.push(displacement);
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
        
        universalBus.playerStartMove.subscribe(this, playerMove); 
        universalBus.beat.subscribe(this, function(beatEvent : BeatEvent) {
            if (targetBeat > beatEvent.beat) {
                if (!playerSafe) {
                    universalBus.playerHit.broadcast(logicalPlayerPosition);
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
            if (unsafeSquare.equals(displacement)) {
                return false;
            }
        }

        return true;
    }
}
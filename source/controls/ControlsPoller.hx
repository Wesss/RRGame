package controls;

import bus.*;
import domain.HorizontalDisplacement;
import domain.VerticalDisplacement;
import domain.Displacement;
import flixel.FlxG;

/**
 * Responsible for polling controller input via haxe flixel's interface
**/
class ControlsPoller {
    private var crates : Array<Displacement>;
    private var isTutorial : Bool;
    public function new(universalBus : UniversalBus) {
        crates = [];
        isTutorial = false;
        universalBus.tutorialFlag.subscribe(this, function(_) {
            isTutorial = true;
            universalBus.tutorialFlag.unsubscribe(this);
        });
        universalBus.crateLanded.subscribe(this, function(location) {
            if (location.horizontalDisplacement == NONE || location.verticalDisplacement == NONE) {
                for (crate in crates) {
                    if (crate.equals(location)) {
                        return;
                    }
                }
                crates.push(location);
            }
        });
        universalBus.crateDestroyed.subscribe(this, function(location) {
            for (crate in crates) {
                if (crate.equals(location)) {
                    crates.remove(crate);
                    return;
                }
            }
        });
        universalBus.beat.subscribe(this, function(beatEvent) {
            if (beatEvent.beat > 5 && !isTutorial) {
                crates = [];
                universalBus.crateLanded.unsubscribe(this);
                universalBus.crateDestroyed.unsubscribe(this);
                universalBus.beat.unsubscribe(this);
            }
        });
    }

    public function getControlsInput() : Displacement {
        var rightDisplacement = 0;
        var downDisplacement = 0;
        if (FlxG.keys.anyPressed([LEFT, A]))
        {
            rightDisplacement--;
        }
        if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            rightDisplacement++;
        }
        if (FlxG.keys.anyPressed([UP, W]))
        {
            downDisplacement--;
        }
        if (FlxG.keys.anyPressed([DOWN, S]))
        {
            downDisplacement++;
        }
        if (isTutorial) {
            for (crate in crates) {
                if (crate.horizontalDisplacement == LEFT && rightDisplacement < 0) {
                    rightDisplacement = 0;
                } else if (crate.horizontalDisplacement == RIGHT && rightDisplacement > 0) {
                    rightDisplacement = 0;
                } else if (crate.verticalDisplacement == UP && downDisplacement < 0) {
                    downDisplacement = 0;
                } else if (crate.verticalDisplacement == DOWN && downDisplacement > 0) {
                    downDisplacement = 0;
                }
            }
        }

        var horDisplacement = null;
        if (rightDisplacement == -1) {
            horDisplacement = HorizontalDisplacement.LEFT;
        } else if (rightDisplacement == 0) {
            horDisplacement = HorizontalDisplacement.NONE;
        } else if (rightDisplacement == 1) {
            horDisplacement = HorizontalDisplacement.RIGHT;
        }

        var verDisplacement = null;
        if (downDisplacement == -1) {
            verDisplacement = VerticalDisplacement.UP;
        } else if (downDisplacement == 0) {
            verDisplacement = VerticalDisplacement.NONE;
        } else if (downDisplacement == 1) {
            verDisplacement = VerticalDisplacement.DOWN;
        }

        return new Displacement(horDisplacement, verDisplacement);
    }
}

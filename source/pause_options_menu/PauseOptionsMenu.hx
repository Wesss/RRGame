package pause_options_menu;

import bus.UniversalBus;
import logging.LoggingSystem;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxSubState;

/**
 * A menu that pauses the game and allows for manipulating persistent options settings
 **/
class PauseOptionsMenu extends FlxSubState {

    // TODO make pause menu unavailable after level end

    private var universalBus:UniversalBus;
    private var logger:LoggingSystem;
    private var levelIndex:Int;

    public function new(universalBus:UniversalBus, logger:LoggingSystem, levelIndex:Int) {
        super();
        this.universalBus = universalBus;
        this.logger = logger;
        this.levelIndex = levelIndex;
    }

    override public function create():Void {
        super.create();
        // TODO draw text
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.R) {
            var oldCallback = this.closeCallback;
            this.closeCallback = function() {
                oldCallback();
                universalBus.retry.subscribe(this, function(_) {
                    PlayLevelState.endPlayState(logger, levelIndex, 0, true);
                });
                universalBus.retry.broadcast(true);
            }
            this.close();
        }

        if (FlxG.keys.justPressed.SPACE) {
            var oldCallback = this.closeCallback;
            this.closeCallback = function() {
                oldCallback();
                universalBus.returnToHub.subscribe(this, function(_) {
                    PlayLevelState.endPlayState(logger, levelIndex, 0, false);
                });
                universalBus.returnToHub.broadcast(true);
            }
            this.close();
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            this.close();
        }
    }
}

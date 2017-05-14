package pause_options_menu;

import flixel.text.FlxText;
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

        var pauseMsg = new FlxText(-50, -40, "PAUSED");
        var volumeMsg = new FlxText(-50, 10, "Press +/- to change Volume");
        var retryMsg = new FlxText(-50, 30, "Press R to restart");
        var exitMsg = new FlxText(-50, 50, "press SPACE to quit to hubworld");

        Juicer.juiceText(pauseMsg, 20);
        Juicer.juiceText(volumeMsg, 20);
        Juicer.juiceText(retryMsg, 20);
        Juicer.juiceText(exitMsg, 20);

        add(pauseMsg);
        add(volumeMsg);
        add(retryMsg);
        add(exitMsg);
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

package pause_options_menu;

import flixel.text.FlxText;
import bus.UniversalBus;
import logging.LoggingSystem;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;

/**
 * A menu that pauses the game and allows for manipulating persistent options settings
 **/
class PauseOptionsMenu extends FlxSubState {

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

        var background = new FlxSprite();
        var seethroughColor = new flixel.util.FlxColor(0xcc2E4172);
        background.makeGraphic(FlxG.width, cast(FlxG.height / 2), seethroughColor);
        background.x -= background.width / 2;
        background.y -= background.height / 2;
        add(background);

        var pauseMsg = new PauseText("PAUSED", 50);
        pauseMsg.y = -120;

        var volumeMsg = new PauseText("[ Press +/- to change the Volume ]", 30);
        volumeMsg.y = -40;
        var retryMsg = new PauseText("[ Press R to restart ]", 30);
        retryMsg.y = 0;
        var exitMsg = new PauseText("[ Press Space to return to Level Select ]", 30);
        exitMsg.y = 40;

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

private class PauseText extends FlxText {
	public function new(text : String, size : Int) {
		super(0, 0, 0, text);
		setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.WHITE, CENTER);
        x -= width/2;
	}
}
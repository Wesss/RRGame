package level;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import bus.UniversalBus;
import flixel.group.FlxSpriteGroup;
import timing.BeatEvent;
import flixel.tweens.*;

class ProgressBar extends FlxSpriteGroup {

    private static inline var X_POSITION = -200;
    private static inline var Y_POSITION = 210;
    private static inline var BAR_LENGTH = 400;

    private var barSprite:FlxSprite;
    private var sliderSprite:FlxSprite;
    private var levelEndBeat:Float;
    private var isProgressing:Bool;

    public function new(universalBus:UniversalBus) {
        super();
        barSprite = new FlxSprite(X_POSITION, Y_POSITION);
        barSprite.makeGraphic(BAR_LENGTH, 12, FlxColor.fromRGB(104, 153, 153));
        sliderSprite = new FlxSprite(X_POSITION, Y_POSITION);
        sliderSprite.makeGraphic(10, 12, FlxColor.fromRGB(255, 227, 171));
        add(barSprite);
        add(sliderSprite);

        universalBus.levelStart.subscribe(this, levelStart);
        universalBus.beat.subscribe(this, updateBeat);
        universalBus.playerDie.subscribe(this, stopProgressing);
        universalBus.levelOutOfBeats.subscribe(this, disappear);
    }

    public function levelStart(event:LevelStartEvent) {
        this.levelEndBeat = event.lastBeat;
        this.isProgressing = true;
    }

    public function updateBeat(event:BeatEvent) {
        if (isProgressing) {
            var percentCoplete = (event.beat / levelEndBeat) * 100;
            if (percentCoplete < 0) {
                percentCoplete = 0;
            }
            if (percentCoplete > 100) {
                percentCoplete = 100;
            }
            sliderSprite.x = X_POSITION + (percentCoplete * BAR_LENGTH / 100);
        }
    }

    public function stopProgressing(_) {
        isProgressing = false;
    }

    public function disappear(_) {
        FlxTween.tween(this.scale, {
            x : 1.2,
            y : 1.2
        }, 0.3, {
            ease : FlxEase.quadIn
        });
        FlxTween.tween(this, {
            alpha : 0
        }, 0.3, {
            ease : FlxEase.quadIn
        });
    }
}

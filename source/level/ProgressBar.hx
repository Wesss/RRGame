package level;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import bus.UniversalBus;
import flixel.group.FlxSpriteGroup;
import timing.BeatEvent;

class ProgressBar extends FlxSpriteGroup {

    private static inline var X_POSITION = -270;
    private static inline var Y_POSITION = 200;

    private var barSprite:FlxSprite;
    private var sliderSprite:FlxSprite;
    private var levelEndBeat:Float;
    private var isProgressing:Bool;

    public function new(universalBus:UniversalBus) {
        super();
        barSprite = new FlxSprite(X_POSITION, Y_POSITION);
        barSprite.makeGraphic(100, 10, FlxColor.WHITE);
        sliderSprite = new FlxSprite(X_POSITION, Y_POSITION);
        sliderSprite.makeGraphic(10, 15, FlxColor.WHITE);
        add(barSprite);
        add(sliderSprite);

        universalBus.levelStart.subscribe(this, levelStart);
        universalBus.beat.subscribe(this, updateBeat);
        universalBus.playerDie.subscribe(this, stopProgressing);
    }

    public function levelStart(event:LevelStartEvent) {
        this.levelEndBeat = event.lastBeat;
        this.isProgressing = true;
    }

    public function updateBeat(event:BeatEvent) {
        if (isProgressing) {
            var completion = Std.int((event.beat / levelEndBeat) * 100);
            if (completion < 0) {
                completion = 0;
            }
            if (completion > 100) {
                completion = 100;
            }
            sliderSprite.x = X_POSITION + completion;
        }
    }

    public function stopProgressing(_) {
        isProgressing = false;
    }
}

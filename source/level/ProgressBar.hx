package level;

import bus.UniversalBus;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import timing.BeatEvent;

class ProgressBar extends FlxText {

    private static inline var X_POSITION = -300;
    private static inline var Y_POSITION = 200;
    private var userInterfaceGroup:FlxSpriteGroup;
    private var levelEndBeat:Float;

    public function new(universalBus:UniversalBus, userInterfaceGroup) {
        this.userInterfaceGroup = userInterfaceGroup;
        super(X_POSITION, Y_POSITION, "");
        setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 16, flixel.util.FlxColor.WHITE, CENTER);

        universalBus.levelStart.subscribe(this, levelStart);
        universalBus.beat.subscribe(this, updateBeat);
    }

    public function levelStart(event:LevelStartEvent) {
        this.levelEndBeat = event.lastBeat;
        this.text = "0% complete";
        userInterfaceGroup.add(this);
    }

    public function updateBeat(event:BeatEvent) {
        var completion = Std.int((event.beat / levelEndBeat) * 100);
        if (completion < 0) {
            completion = 0;
        }
        if (completion > 100) {
            completion = 100;
        }
        this.text =  completion + "% complete";
    }
}

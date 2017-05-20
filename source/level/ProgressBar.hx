package level;

import flixel.text.FlxText;
import timing.BeatEvent;

class ProgressBar extends FlxText {

    private var levelEndBeat:Float;
    private var curBeat:Float;

    public function new(universalBus, levelEndBeat) {
        this.levelEndBeat = levelEndBeat;
        this.curBeat = 0;
        super(100, 100, curBeat / levelEndBeat + "% complete");
        Juicer.juiceText(this, 18);
    }

    public function updateBeat(event:BeatEvent) {
        if (event.beat > 0) {
            this.curBeat = event.beat;
            this.text =  curBeat / levelEndBeat + "% complete";
        }
    }
}

package track_action;

import flixel.text.FlxText;

class TextTrackAction extends FlxText implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    public function new(beatOffset : Float, text : String, bpm : Int, beatDuration = 4) {
        super(-275, -227, text);
        triggerBeats = [0, beatDuration];
        this.beatOffset = beatOffset;

        Juicer.juiceText(this, 22);
        visible = false;
    }

    /**
     * @param curBeat - the current beat RELATIVE to this.beatOffset
     **/
    public function updateBeat(curBeat:Float):Void {

    }

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public function triggerBeat(beatIndex:Int):Void {
        if (beatIndex == 0) {
            // appear
            visible = true;
        } else if (beatIndex == 1) {
            // dissapear
            visible = false;
        }
    }
}
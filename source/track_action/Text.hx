package track_action;

import flixel.text.FlxText;
import board.BoardCoordinates;
import domain.Displacement;
import flixel.tweens.*;

class Text implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    private var text:FlxText;

    public function new(beatOffset : Float, text : String, bpm : Int, beatDuration = 8) {
        triggerBeats = [0, beatDuration];
        this.beatOffset = beatOffset;

        // TODO hook up text
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
            // TODO
        } else if (beatIndex == 1) {
            // dissapear
            // TODO
        }
    }
}
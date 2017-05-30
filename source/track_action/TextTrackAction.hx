package track_action;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class TextTrackAction extends FlxText implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    public function new(beatOffset : Float, xPos : Int, yPos : Int, text : String, bpm : Int, beatDuration = 4) {
        super(xPos, yPos, 0, text);
        triggerBeats = [0, beatDuration];
        this.beatOffset = beatOffset;
        setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 22, FlxColor.WHITE, CENTER);
        setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        this.x -= this.width / 2;
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
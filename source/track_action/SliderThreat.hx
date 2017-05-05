package track_action;

import board.BoardCoordinates;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.tweens.*;

class SliderThreat extends FlxSprite implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    private var bpm : Int;

    public function new(beatOffset : Float, bpm : Int, position : Displacement) {
        super(BoardCoordinates.displacementToX(position.horizontalDisplacement),
              BoardCoordinates.displacementToY(position.verticalDisplacement),
              AssetPaths.BoardSquare__png);

        visible = false;
        triggerBeats = [-3, 0];
        this.beatOffset = beatOffset;
        this.bpm = bpm;
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
        trace(beatIndex);
        visible = true;
        if (beatIndex == 0) {
            set_color(flixel.util.FlxColor.RED);
            FlxTween.tween(this, {
                x : x - width / 2,
                y : y - height / 2
            }, 3 / bpm * 60, {
                ease: FlxEase.quintIn,
                onComplete: function(tween) {
                }
            });
        } else if (beatIndex == 1) {
            set_color(flixel.util.FlxColor.GREEN);
        }
    }
}
package track_action;

import board.BoardCoordinates;
import bus.*;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.tweens.*;

class SliderThreat extends FlxSprite implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    private var bpm : Int;
    private var position : Displacement;
    private var killBus : Bus<Displacement>;

    public function new(beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus) {
        super(BoardCoordinates.displacementToX(position.horizontalDisplacement),
              BoardCoordinates.displacementToY(position.verticalDisplacement),
              AssetPaths.BoardSquare__png);

        visible = false;
        triggerBeats = [-2, 0, 0.1, 1];
        this.beatOffset = beatOffset;
        this.bpm = bpm;
        this.position = position;
        this.killBus = universalBus.threatKillSquare;
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
        visible = true;
        if (beatIndex == 0) {
            // Warning phase of threat

            // Show threat:
            set_color(flixel.util.FlxColor.RED);

            // Animate threat to target square:
            FlxTween.tween(this, {
                x : x - width / 2,
                y : y - height / 2
            }, 2 / bpm * 60, {
                onComplete: function(tween) {
                }
            });
        } else if (beatIndex == 1) {
            // Threat about to collide
            
            // Animate threat disappearing:
            set_color(flixel.util.FlxColor.PURPLE);
        } else if (beatIndex == 2) {
            // Threat collision - a tenth of a beat after landing for tolerance

            killBus.broadcast(position);
            set_color(flixel.util.FlxColor.PINK);
        } else if (beatIndex == 3) {
            // Threat disappear
            visible = false;
        }
    }
}
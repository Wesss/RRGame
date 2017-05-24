package track_action;

import board.BoardCoordinates;
import bus.*;
import domain.Displacement;
import flixel.FlxSprite;

class HealthPickup extends FlxSprite implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    private var universalBus:UniversalBus;
    private var position:Displacement;

    public function new(beatOffset:Float, position:Displacement, universalBus:UniversalBus) {
        super(BoardCoordinates.displacementToX(position.horizontalDisplacement),
              BoardCoordinates.displacementToY(position.verticalDisplacement));
        
        loadGraphic(AssetPaths.HPIndicator__png, false);
        x -= width / 2;
        y -= height / 2;

        this.beatOffset = beatOffset;
        this.universalBus = universalBus;
        this.position = position;
        triggerBeats = [0];
        kill();
    }

    /**
     * @param curBeat - the current beat RELATIVE to this.beatOffset
     **/
    public function updateBeat(curBeat:Float):Void {}

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public function triggerBeat(beatIndex:Int):Void {
        revive();
        angularVelocity = 90;
        universalBus.healthHit.subscribe(this, function(displacement) {
            if (displacement.equals(position)) {
                kill();
            }
        });
        universalBus.healthLanded.broadcast(position);
    }
}
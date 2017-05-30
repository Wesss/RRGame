package track_action;

import board.BoardCoordinates;
import bus.*;
import domain.*;
import flixel.FlxSprite;
import flixel.tweens.*;
import level.ThreatLandedEvent;


class TutorialCrate extends FlxSprite implements TrackAction {
    public var beatOffset:Float;
    public var triggerBeats:Array<Float>;
    private var crateLandedBus : Bus<Displacement>;
    private var crateDestroyedBus : Bus<Displacement>;

    private var position(default, null) : Displacement;
    private var killBus : Bus<ThreatLandedEvent>;

    public function new(beatOffset : Float, position : Displacement, universalBus : UniversalBus, duration = 8.0) {
        super(BoardCoordinates.displacementToX(position.horizontalDisplacement),
              BoardCoordinates.displacementToY(position.verticalDisplacement));
        
        loadGraphic(AssetPaths.CrateThreat__png, true, 112, 112);
        animation.add("warning", [0]);
        animation.add("landed", [1]);

        x -= width / 2;
        y -= height / 2;

        kill();

        triggerBeats = [0, duration];
        this.beatOffset = beatOffset;
        crateLandedBus = universalBus.crateLanded;
        crateDestroyedBus = universalBus.crateDestroyed;

        this.position = position;
        this.killBus = universalBus.threatKillSquare;
    }

    /**
     * @param curBeat - the current beat RELATIVE to this.beatOffset
     **/
    public function updateBeat(curBeat:Float):Void {}

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public function triggerBeat(beatIndex:Int):Void {
        if (beatIndex == 0) {
            revive();
            killBus.broadcast(new ThreatLandedEvent(this, position));
            crateLandedBus.broadcast(position);
            animation.play("landed");
        } else {
            crateDestroyedBus.broadcast(position);
            FlxTween.tween(this, {
                alpha: 0
            }, 1, {
                ease: FlxEase.quadOut,
                onComplete: function(_) {
                    kill();
                }
            });
        }
    }
}
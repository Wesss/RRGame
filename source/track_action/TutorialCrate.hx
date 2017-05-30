package track_action;

import bus.*;
import domain.*;
import flixel.tweens.*;
import level.ThreatLandedEvent;


class TutorialCrate implements TrackAction {
    public var beatOffset:Float;
    public var triggerBeats:Array<Float>;
    private var crateLandedBus : Bus<Displacement>;
    private var crateDestroyedBus : Bus<Displacement>;

    private var position(default, null) : Displacement;
    private var killBus : Bus<ThreatLandedEvent>;

    public function new(beatOffset : Float, position : Displacement, universalBus : UniversalBus, duration = 8.0) {
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
            killBus.broadcast(new ThreatLandedEvent(this, position));
            crateLandedBus.broadcast(position);
        } else {
            crateDestroyedBus.broadcast(position);
        }
    }
}
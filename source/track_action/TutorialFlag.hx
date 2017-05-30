package track_action;

import bus.*;

class TutorialFlag implements TrackAction {
    public var beatOffset:Float;
    public var triggerBeats:Array<Float>;

    private var universalBus:UniversalBus;

    public function new(beatOffset : Float, universalBus : UniversalBus) {
        triggerBeats = [0];
        this.beatOffset = beatOffset;
        this.universalBus = universalBus;
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
        universalBus.tutorialFlag.broadcast(true);
    }
}
package track_action;

import bus.*;
import domain.Displacement;

class HealthPickup implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    public function new(beatOffset:Float, location:Displacement, universalBus:UniversalBus) {
        
    }

    /**
     * @param curBeat - the current beat RELATIVE to this.beatOffset
     **/
    public function updateBeat(curBeat:Float):Void {}

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public function triggerBeat(beatIndex:Int):Void {

    }
}
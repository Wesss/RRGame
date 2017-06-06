package track_action;

import timing.RewindLevelEvent;
import bus.*;
import domain.Displacement;

/**
 * This is a health pickup that will not advance the level until picked up
**/
class HealthPickupTutorial extends HealthPickup {

    private var rewindBus:Bus<RewindLevelEvent>;
    private var isLanded:Bool;
    private var isPickedUp:Bool;

    public function new(beatOffset:Float, position:Displacement, universalBus:UniversalBus) {
        super(beatOffset, position, universalBus);
        this.rewindBus = universalBus.rewindLevel;
        isLanded = false;
        isPickedUp = false;
    }

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    override public function triggerBeat(beatIndex:Int):Void {
        if (!isLanded) {
            isLanded = true;
            super.triggerBeat(beatIndex);
        }
        if (!isPickedUp) {
            rewindBus.broadcast(new RewindLevelEvent(2));
        }
    }

    override public function handleHealthHit(displacement) {
        super.handleHealthHit(displacement);
        isPickedUp = true;
    }
}
package track_action;

import bus.*;
import domain.Displacement;
import timing.RewindLevelEvent;

class RewindSliderThreat extends SliderThreat {
    private var beatsToRewind : Float;
    private var rewindBus : Bus<RewindLevelEvent>;

    public function new(beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus, beatWarnTime : Float, beatsToRewind : Float) {
        super(beatOffset, bpm, position, universalBus, beatWarnTime);
        this.beatsToRewind = beatsToRewind;
        this.rewindBus = universalBus.rewindLevel;
    }
    override public function playerHitHandler(where : Displacement) {
        this.rewindBus.broadcast(new RewindLevelEvent(beatsToRewind));
        super.playerHitHandler(where);
    }
}
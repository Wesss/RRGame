package;

import board.BoardCoordinates;
import bus.*;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.tweens.*;
import track_action.SliderThreat;
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
        if (where == position) {
            animateHit();
        }
    }
}
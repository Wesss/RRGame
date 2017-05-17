package track_action;

import board.BoardCoordinates;
import bus.*;
import domain.Displacement;

class SliderThreatHoming extends SliderThreat {

    private var playerPosition:Displacement;
    private var isStarted:Bool;

    public function new(beatOffset : Float, bpm : Int, universalBus : UniversalBus, beatWarnTime = 2.0) {
        super(beatOffset, bpm, new Displacement(NONE, NONE), universalBus, beatWarnTime);

        playerPosition = new Displacement(NONE, NONE);
        isStarted = false;
        universalBus.playerStartMove.subscribe(this, trackPlayerPosition);
    }

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    override public function triggerBeat(beatIndex:Int):Void {
        if (beatIndex == 0) {
            this.position = playerPosition;
            this.x = BoardCoordinates.displacementToX(position.horizontalDisplacement);
            this.y = BoardCoordinates.displacementToY(position.verticalDisplacement);
            isStarted = true;
        }
        super.triggerBeat(beatIndex);
    }

    public function trackPlayerPosition(displacement : Displacement) {
        if (!isStarted) {
            playerPosition = displacement;
        }
    }
}
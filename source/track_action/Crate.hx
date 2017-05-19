package track_action;

import bus.*;
import domain.Displacement;
import flixel.tweens.*;

class Crate extends SliderThreat {
    private var durationIndex : Int;
    private var crateLandedBus : Bus<Displacement>;
    private var crateDestroyedBus : Bus<Displacement>;

    public function new(beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus, beatWarnTime = 2.0, duration = 8.0) {
        super(beatOffset, bpm, position, universalBus, beatWarnTime);
        
        durationIndex = triggerBeats.length;
        triggerBeats.push(duration);

        crateLandedBus = universalBus.crateLanded;
        crateDestroyedBus = universalBus.crateDestroyed;
    }

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public override function triggerBeat(beatIndex:Int):Void {
        super.triggerBeat(beatIndex);
        if (beatIndex == durationIndex) {
            disappear();
        }
    }

    public override function hit() {
        // Threat collision
        warningTween.cancel(); // In case timing discrepency between beats timing and timer

        killBus.broadcast(position);
        crateLandedBus.broadcast(position);

        scale.x = 1;
        scale.y = 1;
    }

    public function disappear() {
        // Fade and scale out
        FlxTween.tween(this, {
            alpha: 0
        }, 1 / bpm * 60, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                visible = false;
                crateDestroyedBus.broadcast(position);
            }
        });
    }
}
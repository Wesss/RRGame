package track_action;

import level.ThreatLandedEvent;
import bus.*;
import domain.Displacement;
import timing.RewindLevelEvent;
import flixel.tweens.*;

class RewindSliderThreat extends SliderThreat {
    private var beatsToRewind : Float;
    private var rewindBus : Bus<RewindLevelEvent>;
    private var fadeOutTween : FlxTween;
    private var scaleOutTween : FlxTween;

    public function new(beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus, beatWarnTime : Float, beatsToRewind : Float) {
        super(beatOffset, bpm, position, universalBus, beatWarnTime);
        this.beatsToRewind = beatsToRewind;
        this.rewindBus = universalBus.sliderRewindHit;
        universalBus.rewindLevel.subscribe(this, function(_) {
            if (fadeOutTween != null) {
                fadeOutTween.cancel();
                scaleOutTween.cancel();
            }
        });
    }
    override public function playerHitHandler(event : ThreatLandedEvent) {
        if (this == event.trackAction) {
            this.rewindBus.broadcast(new RewindLevelEvent(beatsToRewind));
        }
        super.playerHitHandler(event);
    }
    override public function hit() {
        // Threat collision
        warningTween.cancel(); // In case timing discrepency between beats timing and timer

        killBus.broadcast(new ThreatLandedEvent(this, position));

        scale.x = 1;
        scale.y = 1;

        // Fade and scale out
        fadeOutTween = FlxTween.tween(this, {
            alpha: 0
        }, 1 / bpm * 60, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                kill();
            }
        });

        scaleOutTween = FlxTween.tween(this.scale, {
            x : 1.2,
            y : 1.2
        }, 1 / bpm * 60, {
            ease: FlxEase.quadOut
        });

        animateDodge();
    }
}
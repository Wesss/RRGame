package track_action;

import board.BoardCoordinates;
import bus.*;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.tweens.*;

class SliderThreat extends FlxSprite implements TrackAction {
    public var beatOffset:Float;
    // an array of beats relative the the offset defined above
    public var triggerBeats:Array<Float>;

    private var beatWarnTime : Float;
    private var bpm : Int;
    // PUBLIC FOR TESTING
    public var position(default, null) : Displacement;
    private var killBus : Bus<Displacement>;

    private var target : Displacement;
    private var warningTween : FlxTween;

    public function new(beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus, beatWarnTime = 2.0) {
        super(BoardCoordinates.displacementToX(position.horizontalDisplacement),
              BoardCoordinates.displacementToY(position.verticalDisplacement));
        
        loadGraphic(AssetPaths.RedSliderThreat__png, true, 112, 112);
        animation.add("warning", [0]);
        animation.add("hit", [1]);
        animation.add("dodge", [2]);

        visible = false;
        triggerBeats = [-beatWarnTime, 0, 1];
        this.beatOffset = beatOffset;
        this.beatWarnTime = beatWarnTime;
        this.bpm = bpm;
        this.position = position;
        this.killBus = universalBus.threatKillSquare;
        this.target = position;

        universalBus.playerHit.subscribe(this, playerHitHandler);
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
        if (beatIndex == 0) {
            // Warning phase of threat

            // Show threat:
            visible = true;

            scale.x = 0;
            scale.y = 0;
            x -= width / 2;
            y -= height / 2;

            // Flash open the threat square
            warningTween = FlxTween.tween(this.scale, {
                x : 0.5,
                y : 0.5
            }, 0.1, {
                ease: FlxEase.quartIn
            }).then(FlxTween.tween(this.scale, {
                x : 1.0,
                y : 1.0
            }, beatWarnTime / bpm * 60 - 0.1, {
                ease: FlxEase.quartIn
            }));

            animation.play("warning");
        } else if (beatIndex == 1) {
            // Threat collision
            warningTween.cancel(); // In case timing discrepency between beats timing and timer

            killBus.broadcast(position);

            scale.x = 1;
            scale.y = 1;

            animation.play("dodge");
            // Fade and scale out
            FlxTween.tween(this, {
                alpha: 0
            }, 1 / bpm * 60, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(this.scale, {
                x : 1.2,
                y : 1.2
            }, 1 / bpm * 60, {
                ease: FlxEase.quadOut
            });
        } else if (beatIndex == 2) {
            // Threat disappear
            visible = false;
        }
    }
    
    public function playerHitHandler(where : Displacement) {
        if (where == target) {
            animation.play("hit");
        }
    }
}
package board;

import bus.UniversalBus;
import domain.*;
import flixel.FlxSprite;
import flixel.tweens.*;
import timing.BeatEvent;

class BoardSquare extends FlxSprite {
    private var oldBeat : Float;
    private var crateOnTop : Bool;
    private var isTutorial : Bool;

    public function new(displacement : Displacement, universalBus : UniversalBus) {
        super(0, 0);
        loadGraphic(AssetPaths.BoardSquare__png);
        x = BoardCoordinates.displacementToX(displacement.horizontalDisplacement) - width / 2;
        y = BoardCoordinates.displacementToY(displacement.verticalDisplacement) - height / 2;

        crateOnTop = false;
        isTutorial = false;

        if (universalBus != null) {
            universalBus.beat.subscribe(this, handleBeat);
            universalBus.gameOver.subscribe(this, function(_) {
                universalBus.beat.unsubscribe(this);
                FlxTween.tween(scale, {
                    y : 0,
                    x : 1.1
                }, 0.2, {
                    ease : FlxEase.quadIn
                });
                var explodeScale = 2;
                FlxTween.tween(this, {
                    x : (x + width / 2) * explodeScale + x,
                    y : (y + height / 2) * explodeScale + y
                }, 0.2, {
                    ease : FlxEase.quadIn
                });
            });

            universalBus.crateLanded.subscribe(this, function(landedDisplacement) {
                if (displacement.equals(landedDisplacement)) {
                    crateOnTop = true;
                    if (isTutorial) {
                        alpha = 0;
                    }
                }
            });
            universalBus.crateDestroyed.subscribe(this, function(landedDisplacement) {
                if (displacement.equals(landedDisplacement)) {
                    crateOnTop = false;
                    if (isTutorial) {
                        var targetX = x;
                        var targetY = y;

                        x = (x + width / 2) * 1.4 + x;
                        y = (y + height / 2) * 1.4 + y;
                        
                        FlxTween.tween(this, {
                            x : targetX,
                            y : targetY
                        }, 0.5, {
                            ease : FlxEase.quadOut
                        });
                        FlxTween.tween(this, {
                            alpha : 1
                        }, 0.3, {
                            ease : FlxEase.quadIn
                        });
                    }
                }
            });
            universalBus.tutorialFlag.subscribe(this, function(_) {
                isTutorial = true;
                if (crateOnTop) {
                    alpha = 0;
                }
            });
        }

        oldBeat = 0;
    }

    public function handleBeat(beat : BeatEvent) {
        if (Math.round(oldBeat) >= oldBeat && Math.round(beat.beat) <= beat.beat) {
            scale.x = 1.1;
            scale.y = 1.1;

            FlxTween.tween(this.scale, {
                x : 1.0,
                y : 1.0
            }, 0.2, {
                ease : FlxEase.quadOut
            });
        }
        oldBeat = beat.beat;
    }
}
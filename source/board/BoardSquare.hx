package board;

import bus.UniversalBus;
import domain.*;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.*;
import timing.BeatEvent;

class BoardSquare extends FlxSpriteGroup {
    private var oldBeat : Float;
    private var crateOnTop : Bool;
    private var isTutorial : Bool;

    public function new(displacement : Displacement, universalBus : UniversalBus) {
        super(0, 0);

        var square = new FlxSprite();
        square.loadGraphic(AssetPaths.BoardSquare__png);
        square.x -= square.width / 2;
        square.y -= square.height / 2;
        add(square);
        x = BoardCoordinates.displacementToX(displacement.horizontalDisplacement);
        y = BoardCoordinates.displacementToY(displacement.verticalDisplacement);

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
                    x : x * explodeScale,
                    y : y * explodeScale
                }, 0.2, {
                    ease : FlxEase.quadIn
                });
            });

            universalBus.crateLanded.subscribe(this, function(landedDisplacement) {
                if (displacement.equals(landedDisplacement)) {
                    crateOnTop = true;
                    if (isTutorial) {
                        kill();
                    }
                }
            });
            universalBus.crateDestroyed.subscribe(this, function(landedDisplacement) {
                if (displacement.equals(landedDisplacement)) {
                    crateOnTop = false;
                    if (isTutorial) {
                        revive();
                        var targetX = x;
                        var targetY = y;

                        x = x * 1.4;
                        y = y * 1.4;
                        
                        FlxTween.tween(this, {
                            x : targetX,
                            y : targetY
                        }, 0.5, {
                            ease : FlxEase.quadOut
                        });

                        alpha = 0.1;
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
                    kill();
                }
                var ghost = new FlxSprite();
                ghost.loadGraphic(AssetPaths.GhostKeys__png, true, 80, 80);
                ghost.animation.add("W", [0]);
                ghost.animation.add("A", [1]);
                ghost.animation.add("S", [2]);
                ghost.animation.add("D", [3]);
                ghost.x -= ghost.width / 2;
                ghost.y -= ghost.height / 2;

                var hasGhost = false;
                if (displacement.equals(new Displacement(NONE, UP))) {
                    ghost.animation.play("W");
                    hasGhost = true;
                } else if (displacement.equals(new Displacement(LEFT, NONE))) {
                    ghost.animation.play("A");
                    hasGhost = true;
                } else if (displacement.equals(new Displacement(NONE, DOWN))) {
                    ghost.animation.play("S");
                    hasGhost = true;
                } else if (displacement.equals(new Displacement(RIGHT, NONE))) {
                    ghost.animation.play("D");
                    hasGhost = true;
                }
                if (hasGhost) {
                    add(ghost);
                    universalBus.playerMoved.subscribe(this, function(location) {
                        if (location.equals(displacement)) {
                            FlxTween.tween({}, {}, 10).then(FlxTween.tween(ghost, {
                                alpha : 0
                            }, 1, {
                                ease : FlxEase.quadIn
                            }));
                            universalBus.playerMoved.unsubscribe(this);
                        }
                    });
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
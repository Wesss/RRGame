package board;

import level.ThreatLandedEvent;
import bus.UniversalBus;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Player extends FlxSpriteGroup {
    var playerSprite : FlxSprite;
    var hpIndicators : Array<FlxSprite>;
    var tween : FlxTween;
    var targetX : Float;
    var targetY : Float;
    var uniBus : UniversalBus;
    var oldBeat : Float;
    var updateScaleOnSpeed : Bool;
    var position : Displacement;

    public var hp(default, null) : Int;

    // for graphical tween
    var oldX : Float;
    var oldY : Float;

    public function new(bus : UniversalBus) {
        super();
        //super(-92 / 2, -91 / 2, AssetPaths.Player__png);
        playerSprite = new FlxSprite(-72 / 2, -72 / 2, AssetPaths.Player__png);

        hpIndicators = [
            new FlxSprite(-78 / 2, -78 / 2, AssetPaths.HPIndicator__png),
            new FlxSprite(-78 / 2, -78 / 2, AssetPaths.HPIndicator__png),
            new FlxSprite(-78 / 2, -78 / 2, AssetPaths.HPIndicator__png)
        ];

        for (hpIndicatorIdx in 0...hpIndicators.length) {
            add(hpIndicators[hpIndicatorIdx]);
            hpIndicators[hpIndicatorIdx].angle = 120 * hpIndicatorIdx;
            hpIndicators[hpIndicatorIdx].angularVelocity = 90;
        }

        add(playerSprite);

        targetX = 0;
        targetY = 0;
        uniBus = bus;
        uniBus.controls.subscribe(this, controlEventHandler);
        uniBus.playerHit.subscribe(this, playerHitHandler);
        uniBus.healthHit.subscribe(this, healthHitHandler);
        uniBus.gameOver.subscribe(this, gameOverHandler);
        uniBus.beat.subscribe(this, pulse);
        uniBus.crateHit.subscribe(this, showCrateHit);
        hp = 4;

        oldX = x;
        oldY = y;

        updateScaleOnSpeed = true;
    }

    public override function update(elapsed : Float) {
        super.update(elapsed);
        if (updateScaleOnSpeed) {
            var dx = x - oldX;
            var dy = y - oldY;
            var speed = Math.sqrt(dx * dx + dy * dy);

            oldX = x;
            oldY = y;

            // adjust scale on speed and rotation based on direction
            var newScale = new flixel.math.FlxPoint(1 - speed / 100, 1 + speed / 100);
            if (newScale.x < 0.5) {
                newScale.x = 0.5;
                newScale.y = 1.5;
            }
            playerSprite.scale = newScale;

            setAngle(Math.atan2(dy, dx) * 180 / Math.PI + 90);
        }
    }

    private function setAngle(newAngle : Float) {
        var dA = newAngle - angle;
        angle = newAngle;

        for (hpIndicator in hpIndicators) {
            hpIndicator.angle -= dA;
        }
    }

    public function controlEventHandler(event : Displacement) {
        uniBus.playerStartMove.broadcast(event);
        position = event;

        var targetX = (BoardCoordinates.displacementToX(event.horizontalDisplacement));
        var targetY = (BoardCoordinates.displacementToY(event.verticalDisplacement));

        if (tween != null) {
            tween.cancel();
        }
    
        tween = FlxTween.tween(this, {
            x : targetX,
            y : targetY
        }, 0.07, {
            ease: FlxEase.quadInOut,
            onComplete: function(tween) {
                uniBus.playerMoved.broadcast(event);
            }
        });
    }
    
    public function playerHitHandler(event : ThreatLandedEvent) {
        hp--;
        uniBus.playerHPChange.broadcast(hp);
        if (hp <= 0) {
            uniBus.playerDie.broadcast(event.position);
            uniBus.controls.unsubscribe(this);
            uniBus.beat.unsubscribe(this);
            updateScaleOnSpeed = false;
            FlxTween.tween(playerSprite.scale, {
                x : 0,
                y : 0
            }, 0.6, {
                ease : FlxEase.backIn
            });
        } else {
            // Remove indicators
            var indicator = hpIndicators[hp - 1];
            FlxTween.tween(indicator.scale, {
                x : 1.1,
                y : 1.1
            }, 1, {
                ease : FlxEase.quadIn
            });

            FlxTween.tween(indicator, {
                alpha : 0
            }, 1);
        }
    }

    public function healthHitHandler(_) {
        if (hp < 4) {
            var indicator = hpIndicators[hp - 1];
            FlxTween.tween(indicator.scale, {
                x : 1,
                y : 1
            }, 0.5, {
                ease : FlxEase.quadOut
            });

            FlxTween.tween(indicator, {
                alpha : 1
            }, 0.5);

            hp++;
        }
    }

    public function gameOverHandler(_) {
        uniBus.controls.unsubscribe(this);
        if (hp > 0) {
            FlxTween.tween(this, {
                x : -70,
                y : 0
            }, 1, {
                ease : FlxEase.quadInOut,
                onComplete : function(_) {
                    setAngle(0);
                }
            });
        }

        for (hpIndicatorIdx in 0...hpIndicators.length) {
            hpIndicators[hpIndicatorIdx].angularVelocity = 0;

            var targetAngle = 120 * hpIndicatorIdx + 360 * 4 - 60;
            var scale = 10;
            var dx = Math.sin((targetAngle + 60) *  Math.PI / 180) * scale;
            var dy = Math.cos((targetAngle + 60) *  Math.PI / 180) * scale;
            function pushOutTween(_) {
                FlxTween.tween(hpIndicators[hpIndicatorIdx],
                {
                    x : hpIndicators[hpIndicatorIdx].x + dx,
                    y : hpIndicators[hpIndicatorIdx].y - dy
                }, 0.1, {
                    ease : FlxEase.quadIn
                });
            }
            FlxTween.angle(hpIndicators[hpIndicatorIdx], hpIndicators[hpIndicatorIdx].angle,
                120 * hpIndicatorIdx + 360 * 4 - 60,
                1, {
                    ease : FlxEase.quadIn
                }).wait(hpIndicatorIdx * 0.1 + 0.1).then(
                    FlxTween.tween({}, {}, 0.4, { onComplete : pushOutTween }));
        }
    }

    public function pulse(beat) {
        if (Math.round(oldBeat) >= oldBeat && Math.round(beat.beat) <= beat.beat) {
            playerSprite.scale.x = 1.1;
            playerSprite.scale.y = 1.1;

            FlxTween.tween(playerSprite.scale, {
                x : 1.0,
                y : 1.0
            }, 0.2, {
                ease : FlxEase.quadOut
            });

            for (hpIndicator in hpIndicators) {
                hpIndicator.scale.x = 1.1;
                hpIndicator.scale.y = 1.1;

                FlxTween.tween(hpIndicator.scale, {
                    x : 1.0,
                    y : 1.0
                }, 0.2, {
                    ease : FlxEase.quadOut
                });
            }
        }
        oldBeat = beat.beat;
    }

    public function showCrateHit(cratePosition : Displacement) {
        var startX = BoardCoordinates.displacementToX(position.horizontalDisplacement);
        var startY = BoardCoordinates.displacementToY(position.verticalDisplacement);
        var targetX = (BoardCoordinates.displacementToX(cratePosition.horizontalDisplacement));
        var targetY = (BoardCoordinates.displacementToY(cratePosition.verticalDisplacement));

        if (tween != null) {
            tween.cancel();
        }
    
        tween = FlxTween.tween(this, {
            x : startX + (targetX - startX) / 3,
            y : startY + (targetY - startY) / 3 
        }, 0.03, {
            ease: FlxEase.quadIn
        }).then(FlxTween.tween(this, {
            x : startX,
            y : startY
        }, 0.03, {
            ease: FlxEase.quadOut
        }));
    }
}
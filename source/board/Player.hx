package board;

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
        hp = 4;

        oldX = x;
        oldY = y;
    }

    public override function update(elapsed : Float) {
        super.update(elapsed);

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

        var newAngle = Math.atan2(dy, dx) * 180 / Math.PI + 90;
        var dA = newAngle - angle;
        angle = newAngle;

        for (hpIndicator in hpIndicators) {
            hpIndicator.angle -= dA;
        }
    }

    public function controlEventHandler(event : Displacement) {
        uniBus.playerStartMove.broadcast(event);

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
    
    public function playerHitHandler(whichSquareHit : Displacement) {
        hp--;
        uniBus.playerHPChange.broadcast(hp);
        if (hp <= 0) {
            uniBus.playerDie.broadcast(whichSquareHit);
            uniBus.controls.unsubscribe(this);
        } else {
            // Remove indicators
            var indicator = hpIndicators[3 - hp];
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
}
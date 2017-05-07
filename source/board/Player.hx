package board;

import bus.UniversalBus;
import domain.Displacement;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Player extends FlxSprite {
    var tween : FlxTween;
    var targetX : Float;
    var targetY : Float;
    var uniBus : UniversalBus;

    var hp : Int;

    // for graphical tween
    var oldX : Float;
    var oldY : Float;

    public function new(bus : UniversalBus) {
        super(-92, -91, AssetPaths.Player__png);
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
            newScale = new flixel.math.FlxPoint(0.5, 1.5);
        }
        scale = newScale;
        angle = Math.atan2(dy, dx) * 180 / Math.PI + 90;
        trace(speed);
    }

    public function controlEventHandler(event : Displacement) {
        uniBus.playerStartMove.broadcast(event);

        var targetX = (BoardCoordinates.displacementToX(event.horizontalDisplacement)) - width / 2;
        var targetY = (BoardCoordinates.displacementToY(event.verticalDisplacement)) - width / 2;

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
            trace("Player died");
        }
        trace("Current hp: " + hp);
    }
}
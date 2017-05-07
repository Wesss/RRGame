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

    public function new(bus : UniversalBus) {
        super(-150, -150, AssetPaths.Player__png);
        targetX = 0;
        targetY = 0;
        uniBus = bus;
        uniBus.controls.subscribe(this, controlEventHandler);
        uniBus.playerHit.subscribe(this, playerHitHandler);
        hp = 4;
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
        }, 0.05, {
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
package level;

import bus.UniversalBus;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Player extends FlxSprite {
    var tween : FlxTween;
    var targetX : Float;
    var targetY : Float;
    var uniBus : UniversalBus;

    public function new(bus : UniversalBus) {
        super(-150, -150, AssetPaths.Player__png);
        targetX = 0;
        targetY = 0;
        uniBus = bus;
        uniBus.controls.subscribe(this, controlEventHandler);
    }

    public function controlEventHandler(event : domain.Displacement) {
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
}
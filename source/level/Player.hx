package level;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Player extends FlxSprite {
    var tween : FlxTween;

    public function new(bus : bus.UniversalBus) {
        super(-150, -150, AssetPaths.Player__png);
        bus.controlsEvents.subscribe(this, controlEventHandler);
    }

    public function controlEventHandler(event : domain.Displacement) {
        var targetX = (BoardCoordinates.displacementToX(event.horizontalDisplacement)) - width / 2;
        var targetY = (BoardCoordinates.displacementToY(event.verticalDisplacement)) - width / 2;
        var distanceX = x - targetX;
        var distanceY = y - targetY;
        var distance = Math.sqrt(distanceX * distanceX + distanceY * distanceY);

        if (tween == null || tween.finished ) {
            tween = FlxTween.tween(this, {
                x : targetX,
                y : targetY
            }, 0.1, { ease: FlxEase.quadInOut });
        } else {
            tween.then(FlxTween.tween(this, {
                x : targetX,
                y : targetY
            }, 0.1, { ease: FlxEase.quadInOut }));
        }
        
        
        
    }
}
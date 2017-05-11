package board;

import bus.UniversalBus;
import flixel.FlxSprite;
import flixel.tweens.*;
import timing.BeatEvent;

class BoardSquare extends FlxSprite {
    private var oldBeat : Float;

    public function new(x : Float, y : Float, universalBus : UniversalBus) {
        super(x, y, AssetPaths.BoardSquare__png);

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
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
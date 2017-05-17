package audio;

import flixel.system.FlxSound;
import flash.media.Sound;

class StreamSound extends FlxSound {
    public function new (openflSound : Sound, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:Void->Void) {
        super();

        cleanup(true);
        _sound = openflSound;
        init(Looped, AutoDestroy, OnComplete);
    }

    public function progress() {
        return _sound.bytesTotal + " " + _sound.bytesLoaded + " " + _sound.length;
    }
}
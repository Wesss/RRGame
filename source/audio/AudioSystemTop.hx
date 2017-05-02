package audio;

import flixel.FlxG;
import bus.Bus.Receiver;
import bus.UniversalBus;

/**
 * Top level module for controlling audio. Responsible for loading/playing of sounds at precise times.
 * This class is NOT responsible for any sort of timing coordination
 **/
class AudioSystemTop implements Receiver<AudioEvent> {
    public function new(universalBus:UniversalBus) {
        universalBus.audioEvents.subscribe(this);
    }

    public function receive(event:AudioEvent) {
        var soundAsset = null;
        if (event.isMusicTrack()) {
            switch (event.musicTrack) {
                case MusicTrack.TEST_TRACK : soundAsset = AssetPaths.TestTrack__ogg;
            }
        } else if (event.isSoundEffect()) {
            switch (event.soundEffect) {
                default : //TODO delete after adding sound effects
            }
        }

        FlxG.sound.playMusic(soundAsset, 1, true);
    }
}

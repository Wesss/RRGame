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
        // TODO music must be in .ogg format
        FlxG.sound.playMusic(AssetPaths.TestTrack__ogg, 1, true);
    }
}

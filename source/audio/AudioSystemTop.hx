package audio;

import flixel.FlxG;
import domain.Displacement;
import bus.UniversalBus;

/**
 * Top level module for controlling audio. Responsible for loading/playing of sounds.
 * This class is NOT responsible for any sort of precise timing or coordination
 **/
class AudioSystemTop {

    private var moveSound = FlxG.sound.load(AssetPaths.NFFsquirt02__wav);

    public function new(universalBus:UniversalBus) {
        universalBus.controlsEvents.subscribe(playMovementSounds);
    }

    public function playMovementSounds(event:Displacement):Void {
        moveSound.play(false, 0, 50);
    }
}

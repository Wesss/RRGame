package audio;

import flixel.system.FlxSound;
import flixel.FlxBasic;
import flixel.FlxG;
import domain.Displacement;
import bus.UniversalBus;

/**
 * Top level module for controlling audio. Responsible for loading/playing of sounds.
 * This class is NOT responsible for any sort of precise timing or coordination
 **/
class AudioSystemTop {

    private var moveSound = FlxG.sound.load(AssetPaths.NFFsquirt02__wav);
    private var musicForLevel:FlxSound;
    private var isPlayingMusic:Bool;

    public function new(universalBus:UniversalBus) {
        musicForLevel = null;
        isPlayingMusic = false;
        universalBus.controlsEvents.subscribe(this, playMovementSounds);
        // TODO hook up music loading/playing to appropriate busses
    }

    public function playMovementSounds(event:Displacement):Void {
        moveSound.play(false, 0, 50);
    }

    /**
     * Prepare to play music specifically for a level
     **/
    public function loadMusicForLevel(loadLevelEvent):Void {
        // TODO pass in level data object, hook this method up to appropriate bus,
        // TODO and load in music associated with level

        if (musicForLevel != null) {
            throw "Music for level has already been loaded";
        }
        musicForLevel = FlxG.sound.load(AssetPaths.Regards_from_Mars__ogg);
    }

    /**
     * Start playing music specifically for a level
     **/
    public function playMusicForLevel(playLevelEvent):Void{
        // TODO pass in level data object, hook this method up to appropriate bus,
        // TODO and play in music associated with level

        if (musicForLevel == null) {
            throw "No Music has been loaded";
        }
        if (isPlayingMusic) {
            throw "Cannot play level music whilst previous level music is still running";
        }
        musicForLevel.play();
        isPlayingMusic = true;
    }
}

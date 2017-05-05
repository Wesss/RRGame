package audio;

import bus.Bus;
import level.LevelData;
import level.LevelEvent;
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

    private var musicBus:Bus<FlxSound>;
    private var moveSound = FlxG.sound.load(AssetPaths.NFFsquirt02__wav);
    private var musicForLevel:FlxSound;
    private var isPlayingMusic:Bool;

    public function new(universalBus:UniversalBus) {
        musicBus = universalBus.musicStart;
        musicForLevel = null;
        isPlayingMusic = false;

        universalBus.controls.subscribe(this, playMovementSounds);
        universalBus.level.subscribe(this, switchLevelState);
    }

    public function playMovementSounds(event:Displacement):Void {
        moveSound.play(false, 0, 50);
    }

    public function switchLevelState(event:LevelEvent):Void {
        switch (event.levelState) {
            case LOAD: loadMusicForLevel(event.levelData);
            case START: playMusicForLevel(event.levelData);
            case WIN:
            case LOSE:
        }
    }

    /**
     * Prepare to play music specifically for a level
     **/
    public function loadMusicForLevel(levelData:LevelData):Void {
        // TODO pass in level data object, hook this method up to appropriate bus,
        // TODO and load in music associated with level

        if (musicForLevel != null) {
            throw "Music for level has already been loaded";
        }
        musicForLevel = FlxG.sound.load(levelData.musicTrack);
    }

    /**
     * Start playing music specifically for a level
     **/
    public function playMusicForLevel(levelData:LevelData):Void{
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
        musicBus.broadcast(musicForLevel);
    }
}

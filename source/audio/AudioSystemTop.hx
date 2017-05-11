package audio;

import bus.Bus;
import level.LevelData;
import level.LevelEvent;
import flixel.system.FlxSound;
import flixel.FlxG;
import domain.Displacement;
import bus.UniversalBus;

/**
 * Top level module for controlling audio. Responsible for loading/playing of sounds.
 * This class is NOT responsible for any sort of precise timing or coordination
 **/
class AudioSystemTop {

    // music
    private var musicBus:Bus<FlxSound>;
    private var musicForLevel:FlxSound;
    private var isPlayingMusic:Bool;

    // sounds
    private var hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
    private var deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);

    public function new(universalBus:UniversalBus) {
        musicBus = universalBus.musicStart;
        musicForLevel = null;
        isPlayingMusic = false;

        hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
        hitSound.volume = .7;
        deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);
        deathSound.volume = .7;
        deathSound.fadeOut(1, .3);


        // music playing
        universalBus.level.subscribe(this, switchLevelState);

        // sound playing
        universalBus.playerHit.subscribe(this, function (event) {
            hitSound.pause();
            hitSound.time = 0;
            hitSound.play();
        });
        // purposefully played along with hit sound
        universalBus.playerDie.subscribe(this, function (event) {
            deathSound.play();
        });
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
        if (musicForLevel != null) {
            throw "Music for level has already been loaded";
        }
        musicForLevel = FlxG.sound.load(levelData.musicTrack);
    }

    /**
     * Start playing music specifically for a level
     **/
    public function playMusicForLevel(levelData:LevelData):Void{
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

package audio;

import flixel.FlxBasic;
import bus.Bus;
import level.LevelData;
import level.LevelEvent;
import flixel.system.FlxSound;
import flixel.FlxG;
import bus.UniversalBus;

/**
 * Top level module for controlling audio. Responsible for loading/playing of sounds.
 * This class is NOT responsible for any sort of precise timing or coordination
 **/
class AudioSystemTop extends FlxBasic {

    // music
    private var musicPlayheadUpdate:Bus<Float>;
    private var musicForLevel:FlxSound;
    private var streamedMusic:StreamSound;
    private var isPlayingMusic:Bool;
    private var prevMusicPlayhead:Float;

    // sounds
    private var hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
    private var deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);

    public function new(universalBus:UniversalBus) {
        super();
        musicPlayheadUpdate = universalBus.musicPlayheadUpdate;
        musicForLevel = null;
        isPlayingMusic = false;

        hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
        hitSound.volume = .7;
        deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);
        deathSound.volume = .7;
        deathSound.fadeOut(1, .3);

        // music playing
        universalBus.level.subscribe(this, switchLevelState);
        universalBus.pause.subscribe(this, pause);
        universalBus.unpause.subscribe(this, unpause);

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

        /*openfl.Assets.loadMusic(levelData.musicAssetPath).onComplete(function(sound) {
            trace("Stream started");
            streamedMusic = new StreamSound(sound, false, true);
            trace("Is playing B" + streamedMusic.playing);
            streamedMusic.play();
            trace("Is playing A" + streamedMusic.playing);
            trace("Stream time:" + streamedMusic.time);
        }).onError(function (error) {
            trace("Stream error: " + error);
        });*/
        var musicCached = FlxG.sound.cache(levelData.musicAssetPath);
        musicForLevel = new StreamSound(musicCached, false, true);
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
        var musicTime = musicForLevel.time;
        prevMusicPlayhead = musicTime;
        musicPlayheadUpdate.broadcast(musicTime);
    }

    override public function update(elapsed:Float) {
        if (musicForLevel == null || !musicForLevel.playing) {
            return;
        }

        var musicTime = musicForLevel.time;
        trace("Mtime: " + musicTime);
        if (musicTime != prevMusicPlayhead) {
            prevMusicPlayhead = musicTime;
            musicPlayheadUpdate.broadcast(musicTime);
        }

        if (streamedMusic != null) {
            trace("Stream time:" + streamedMusic.time);
            if (streamedMusic.time == 0) {
                streamedMusic.pause();
                streamedMusic.play();
            }
        }
    }

    public function pause(pauseEvent) {
        musicForLevel.pause();
    }

    public function unpause(unpauseEvent) {
        musicForLevel.resume();
    }
}

package audio;

import timing.RewindTimingEvent;
import level.LevelStartEvent;
import level.LevelLoadEvent;
import flixel.FlxBasic;
import bus.Bus;
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
    private var musicLoaded:Bus<Bool>;
    private var isPlayingMusic:Bool;
    private var prevMusicPlayhead:Float;
    private var loaded:Bool;

    // sounds
    private var hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
    private var deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);
    private var healthUpSound = FlxG.sound.load(AssetPaths.NFFcoin04__ogg);

    public function new(universalBus:UniversalBus) {
        super();
        musicPlayheadUpdate = universalBus.musicPlayheadUpdate;
        musicLoaded = universalBus.musicLoaded;
        isPlayingMusic = false;

        hitSound.volume = .7;
        deathSound.volume = .7;
        deathSound.fadeOut(1, .3);
        healthUpSound.volume = .7;

        // music playing
        universalBus.levelLoad.subscribe(this, loadMusicForLevel);
        universalBus.levelStart.subscribe(this, playMusicForLevel);
        universalBus.pause.subscribe(this, pause);
        universalBus.unpause.subscribe(this, unpause);
        universalBus.rewindTiming.subscribe(this, rewind);

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
        universalBus.healthHit.subscribe(this, function (event) {
            healthUpSound.play();
        });

        universalBus.gameOver.subscribe(this, function (event) {
            universalBus.pause.unsubscribe(this);
            universalBus.unpause.unsubscribe(this);
        });
    }

    /**
     * Prepare to play music specifically for a level
     **/
    public function loadMusicForLevel(event:LevelLoadEvent):Void {
        loaded = false;        
        FlxG.sound.music = new FlxSound();
        FlxG.sound.music.loadStream(event.levelData.musicAssetPath, false, false);
        FlxG.sound.music.play(true);
    }

    /**
     * Start playing music specifically for a level
     **/
    public function playMusicForLevel(event:LevelStartEvent):Void{
        FlxG.sound.music.play();
        isPlayingMusic = true;
        var musicTime = FlxG.sound.music.time;
        prevMusicPlayhead = musicTime;
        musicPlayheadUpdate.broadcast(musicTime);
    }

    override public function update(elapsed:Float) {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
            return;
        }

        var musicTime = FlxG.sound.music.time;
        if (!loaded && FlxG.sound.music.time == 0) {
            // Load the music
            FlxG.sound.music.pause();
            FlxG.sound.music.resume();
        } else if (!loaded && FlxG.sound.music.time > 0) {
            // Music is finally loaded
            musicLoaded.broadcast(true);
            loaded = true;
        }

        if (musicTime != prevMusicPlayhead) {
            prevMusicPlayhead = musicTime;
            musicPlayheadUpdate.broadcast(musicTime);
        }
    }

    public function pause(pauseEvent) {
        FlxG.sound.music.pause();
        isPlayingMusic = false;
    }

    public function unpause(unpauseEvent) {
        FlxG.sound.music.resume();
        isPlayingMusic = true;
    }

    public function rewind(event:RewindTimingEvent) {
        FlxG.sound.music.pause();
        FlxG.sound.music.time = FlxG.sound.music.time +
                event.milisecondsSinceLastMusicPlayheadUpdate -
                event.milisecondsToRewind;
    }
}

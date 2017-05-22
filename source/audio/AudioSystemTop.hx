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
    private var streamedMusic:StreamSound;
    private var isPlayingMusic:Bool;
    private var prevMusicPlayhead:Float;

    // sounds
    private var hitSound = FlxG.sound.load(AssetPaths.NFFdirthit__ogg);
    private var deathSound = FlxG.sound.load(AssetPaths.NFFdisappear__ogg);

    public function new(universalBus:UniversalBus) {
        super();
        musicPlayheadUpdate = universalBus.musicPlayheadUpdate;
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

        universalBus.gameOver.subscribe(this, function (event) {
            if (FlxG.sound.music != null) {
                FlxG.sound.music.stop();
                FlxG.sound.music = null;
            }
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
        FlxG.sound.music = new FlxSound();
        FlxG.sound.music.loadStream(levelData.musicAssetPath, false, false);
        FlxG.sound.music.play(true);
    }

    /**
     * Start playing music specifically for a level
     **/
    public function playMusicForLevel(levelData:LevelData):Void{
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
        if (FlxG.sound.music.time == 0 && isPlayingMusic) {
            FlxG.sound.music.pause();
            FlxG.sound.music.resume();
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
}

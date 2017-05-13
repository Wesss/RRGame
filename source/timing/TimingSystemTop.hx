package timing;

import flixel.math.FlxMath;
import haxe.Timer;
import bus.Bus;
import bus.UniversalBus;
import flixel.FlxBasic;
import flixel.system.FlxSound;
import level.LevelData;
import level.LevelEvent;

/**
 * Responsible for the coordination between music playing and broadcasting when its beats occur
 **/
class TimingSystemTop extends FlxBasic {

    public static inline var MILISECONDS_PER_MINUTE = 60000.0;

    private var beatEventBus:Bus<BeatEvent>;
    private var milisecondsPerBeat:Float;
    private var offsetMilis:Float;
    private var music:FlxSound;
    private var prevMusicHeadPlayTime:Null<Float>;
    private var prevMusicTimeStamp:Float;
    private var wasPausedSinceLastMusicHeadUpdate:Bool;
    private var lastBeatBroadcasted:Float;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        milisecondsPerBeat = 0;
        offsetMilis = 0;
        music = null;
        prevMusicHeadPlayTime = 0;
        prevMusicTimeStamp = 0;
        wasPausedSinceLastMusicHeadUpdate = false;
        lastBeatBroadcasted = FlxMath.MIN_VALUE_FLOAT;

        universalBus.level.subscribe(this, switchLevelState);
        universalBus.musicStart.subscribe(this, trackSongStart);
        universalBus.pause.subscribe(this, pause);
    }

    public function switchLevelState(event:LevelEvent):Void {
        switch (event.levelState) {
            case LOAD: loadMusicInformation(event.levelData);
            case START:
            case WIN:
            case LOSE:
        }
    }

    /**
     * Save information on the music that is about to be played
     **/
    public function loadMusicInformation(levelData:LevelData):Void {
        this.milisecondsPerBeat = MILISECONDS_PER_MINUTE / levelData.bpm;
        this.offsetMilis = levelData.songStartOffsetMilis;
    }

    /**
     * Start releasing beat events as a song starts playing
     **/
    public function trackSongStart(music:FlxSound):Void {
        this.music = music;
        this.prevMusicHeadPlayTime = null;
    }

    /**
     * If a song is playing, update our time and release beat events as appropriate
     **/
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // if song hasnt started, nothing to do
        if (music == null) {
            return;
        }

        var curStamp = haxe.Timer.stamp() * 1000;
        if (prevMusicHeadPlayTime != music.time) {
            prevMusicHeadPlayTime = music.time;
            prevMusicTimeStamp = curStamp;
            wasPausedSinceLastMusicHeadUpdate = false;
        }

        if (!wasPausedSinceLastMusicHeadUpdate) {
            var curBeat = (prevMusicHeadPlayTime + ((curStamp) - prevMusicTimeStamp) - offsetMilis) / milisecondsPerBeat;

            if (curBeat > lastBeatBroadcasted) {
                beatEventBus.broadcast(new BeatEvent(curBeat));
            }
        }
    }

    public function pause():Void {
        wasPausedSinceLastMusicHeadUpdate = true;
    }
}

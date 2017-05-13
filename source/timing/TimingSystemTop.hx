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
    private var prevMusicHeadPlayTime:Null<Float>;
    private var prevMusicTimeStamp:Float;
    private var isOffSync:Bool;
    private var lastBeatBroadcasted:Float;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        milisecondsPerBeat = 0;
        offsetMilis = 0;
        prevMusicHeadPlayTime = 0;
        prevMusicTimeStamp = 0;
        isOffSync = true;
        lastBeatBroadcasted = -9999999;

        universalBus.level.subscribe(this, switchLevelState);
        universalBus.musicPlayheadUpdate.subscribe(this, updateMusicPlayhead);
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
     * If a song is playing, update our time and release beat events as appropriate
     **/
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var curStamp = haxe.Timer.stamp() * 1000;

        if (!isOffSync) {
            var curBeat = (prevMusicHeadPlayTime + ((curStamp) - prevMusicTimeStamp) - offsetMilis) / milisecondsPerBeat;

            if (curBeat > lastBeatBroadcasted) {
                beatEventBus.broadcast(new BeatEvent(curBeat));
            }
        }
    }

    public function updateMusicPlayhead(playheadTime:Float) {
        prevMusicHeadPlayTime = playheadTime;
        prevMusicTimeStamp = haxe.Timer.stamp() * 1000;
        isOffSync = false;
    }

    public function pause(pauseEvent):Void {
        isOffSync = true;
    }
}

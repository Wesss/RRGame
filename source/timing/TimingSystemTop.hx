package timing;

import level.LevelLoadEvent;
import haxe.Timer;
import bus.Bus;
import bus.UniversalBus;
import flixel.FlxBasic;

/**
 * Responsible for the coordination between music playing and broadcasting when its beats occur
 **/
class TimingSystemTop extends FlxBasic {

    public static inline var MILISECONDS_PER_MINUTE = 60000.0;

    private var milisecondsPerBeat:Float;
    private var offsetMilis:Float;
    private var prevMusicHeadPlayTime:Null<Float>;
    private var prevMusicTimeStamp:Float;
    private var isOffSync:Bool;

    private var beatEventBus:Bus<BeatEvent>;
    private var rewindTimingBus:Bus<RewindTimingEvent>;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        rewindTimingBus = universalBus.rewindTiming;
        milisecondsPerBeat = 0;
        offsetMilis = 0;
        prevMusicHeadPlayTime = 0;
        prevMusicTimeStamp = 0;
        isOffSync = true;

        universalBus.levelLoad.subscribe(this, loadMusicInformation);
        universalBus.musicPlayheadUpdate.subscribe(this, updateMusicPlayhead);
        universalBus.pause.subscribe(this, pause);
        universalBus.rewindLevel.subscribe(this, rewind);
    }

    /**
     * Save information on the music that is about to be played
     **/
    public function loadMusicInformation(event:LevelLoadEvent):Void {
        this.milisecondsPerBeat = MILISECONDS_PER_MINUTE / event.levelData.bpm;
        this.offsetMilis = event.levelData.songStartOffsetMilis;
    }

    /**
     * If a song is playing, update our time and release beat events as appropriate
     **/
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (!isOffSync && prevMusicHeadPlayTime != 0) {
            beatEventBus.broadcast(new BeatEvent(getCurBeat()));
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

    public function rewind(event:RewindLevelEvent):Void {
        var curBeat = getCurBeat();
        var beatRewindingTo = Math.floor((curBeat ) * 2) / 2 - event.beatsToRewind;
        var actualBeatsToRewind = curBeat - beatRewindingTo;
        var milisecondsToRewind = actualBeatsToRewind * milisecondsPerBeat;
        var milisecondsSinceLastMusicPlayheadUpdate = getTimeStampMilis() - prevMusicTimeStamp;

        isOffSync = true;

        rewindTimingBus.broadcast(new RewindTimingEvent(
                milisecondsToRewind,
                milisecondsSinceLastMusicPlayheadUpdate,
                beatRewindingTo));
    }

    private static function getTimeStampMilis():Float {
        return haxe.Timer.stamp() * 1000;
    }

    private function getCurBeat():Float {
        return (prevMusicHeadPlayTime + ((getTimeStampMilis()) - prevMusicTimeStamp) - offsetMilis) / milisecondsPerBeat;
    }
}

package timing;

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
    private var prevMusicHead:Float;
    private var prevMusicStamp:Float;
    private var wasPausedSinceLastMusicHeadUpdate:Bool;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        milisecondsPerBeat = null;
        offsetMilis = null;
        music = null;
        prevMusicHead = 0;
        prevMusicStamp = 0;
        wasPausedSinceLastMusicHeadUpdate = false;

        universalBus.level.subscribe(this, switchLevelState);
        universalBus.musicStart.subscribe(this, trackSongStart);
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
        // TODO change to take in level load event and hook up to bus
        this.milisecondsPerBeat = MILISECONDS_PER_MINUTE / levelData.bpm;
        this.offsetMilis = levelData.songStartOffsetMilis;
    }

    /**
     * Start releasing beat events as a song starts playing
     **/
    public function trackSongStart(music:FlxSound):Void {
        this.music = music;
        this.prevMusicHead = null;
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
        if (prevMusicHead != music.time) {
            prevMusicHead = music.time;
            prevMusicStamp = curStamp;
            wasPausedSinceLastMusicHeadUpdate = false;
        }

        if (!wasPausedSinceLastMusicHeadUpdate) {
            var curBeat = (prevMusicHead + ((curStamp) - prevMusicStamp) - offsetMilis) / milisecondsPerBeat;
            trace(curBeat);
            beatEventBus.broadcast(new BeatEvent(curBeat));
        }
    }

    public function pause():Void {
        wasPausedSinceLastMusicHeadUpdate = true;
    }
}

package timing;

import flixel.FlxBasic;
import bus.Bus;
import bus.UniversalBus;

/**
 * Responsible for the coordination between music playing and broadcasting when its beats occur
 **/
class TimingSystemTop extends FlxBasic {
    // TODO may have to use flash/nme.events.SampleDataEvent for precise timing

    public static inline var MILISECONDS_PER_MINUTE = 60000.0;

    private var beatEventBus:Bus<BeatEvent>;
    private var milisecondsPerBeat:Float;
    private var offsetMilis:Float;
    private var songStartTimeMilis:Float;
    private var nextBeatBroadcast:Int;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beatEvents;
        milisecondsPerBeat = null;
        offsetMilis = null;
        songStartTimeMilis = null;
        nextBeatBroadcast = -1;
        // TODO hook up to bus once level system is more fleshed out
    }

    /**
     * Save information on the music that is about to be played
     **/
    public function loadMusicInformation(bpm:Int, offsetMilis:Float):Void {
        // TODO change to take in level load event and hook up to bus
        this.milisecondsPerBeat = MILISECONDS_PER_MINUTE / bpm;
        this.offsetMilis = offsetMilis;
    }

    /**
     * Start releasing beat events as a song starts playing
     **/
    public function trackSongStart():Void {
        songStartTimeMilis = Date.now().getTime() + offsetMilis;
    }

    /**
     * If a song is playing, update our time and release beat events as appropriate
     **/
    override public function update(elapsed:Float):Void {
        // if song hasnt started, nothing to do
        if (songStartTimeMilis == null) {
            return;
        }

        var songTime = Date.now().getTime() - songStartTimeMilis;
        if (songTime >= milisecondsPerBeat * nextBeatBroadcast) {
            beatEventBus.broadcast(new BeatEvent(nextBeatBroadcast));
            nextBeatBroadcast++;
        }
    }

    /**
     * re-align the timing when we know for sure our place in the music
     **/
    public function updateMusicPlayhead():Void {

    }
}

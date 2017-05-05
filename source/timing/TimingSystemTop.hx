package timing;

import level.LevelData;
import level.LevelEvent;
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

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        milisecondsPerBeat = null;
        offsetMilis = null;
        songStartTimeMilis = null;

        universalBus.level.subscribe(this, switchLevelState);
    }

    public function switchLevelState(event:LevelEvent):Void {
        switch (event.levelState) {
            case LOAD: loadMusicInformation(event.levelData);
            case START: trackSongStart(event.levelData);
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
    public function trackSongStart(levelData):Void {
        songStartTimeMilis = getCurrentTimeMilis() + offsetMilis;
    }

    /**
     * If a song is playing, update our time and release beat events as appropriate
     **/
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // if song hasnt started, nothing to do
        if (songStartTimeMilis == null) {
            return;
        }

        var songTime = getCurrentTimeMilis() - songStartTimeMilis;
        beatEventBus.broadcast(new BeatEvent(songTime / milisecondsPerBeat));
    }

    private static function getCurrentTimeMilis():Float {
        return haxe.Timer.stamp() * 1000;
    }
}

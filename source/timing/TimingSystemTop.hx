package timing;

import flixel.system.FlxSound;
import flixel.FlxG;
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
    private var music:FlxSound;

    public function new(universalBus:UniversalBus) {
        super();
        beatEventBus = universalBus.beat;
        milisecondsPerBeat = null;
        offsetMilis = null;
        music = null;

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

        var songTime = music.time;
        beatEventBus.broadcast(new BeatEvent(songTime / milisecondsPerBeat));
    }

    public function pause():Void {
        trace("pause");
    }

    public function resume():Void {
        trace("resume");
    }
}

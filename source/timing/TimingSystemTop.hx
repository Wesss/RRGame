package timing;

import bus.Bus;
import bus.UniversalBus;

/**
 * Responsible for the coordination between music playing and broadcasting when its beats occur
 **/
class TimingSystemTop {
    // TODO may have to use flash/nme.events.SampleDataEvent for precise timing

    private var beatEventBus:Bus<BeatEvent>;

    public function new(universalBus:UniversalBus) {
        beatEventBus = universalBus.beatEvents;
        // TODO hook up to bus once level system is more fleshed out
    }

    /**
     * Start releasing beat events as a song starts playing
     **/
    public function trackSongStart() {

    }

    /**
     * If a song is playing, update our time and release beat events as appropriate
     **/
    public function update() {

    }

    /**
     * re-align the timing when we know for sure our place in the music
     **/
    public function updateMusicPlayhead() {

    }
}

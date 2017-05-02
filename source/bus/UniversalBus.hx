package bus;

import domain.Displacement;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
import audio.AudioEvent;
class UniversalBus {
    // Add different bus as properties to this class. See below for an example

    public var audioEvents(default, null):Bus<AudioEvent> = new Bus<AudioEvent>();

    public var controlsEvents(default, null):Bus<Displacement> = new Bus<Displacement>();

    public function new() {
    }
}
package bus;

import timing.BeatEvent;
import domain.Displacement;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
class UniversalBus {

    public var controlsEvents(default, null):Bus<Displacement> = new Bus<Displacement>();

    public var beatEvents(default, null):Bus<BeatEvent> = new Bus<BeatEvent>();

    public function new() {}
}
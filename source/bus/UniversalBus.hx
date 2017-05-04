package bus;

import level.LevelEvent;
import domain.Displacement;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
class UniversalBus {

    public var controlsEvents(default, null):Bus<Displacement> = new Bus<Displacement>();

    public var levelEvents(default, null):Bus<LevelEvent> = new Bus<LevelEvent>();

    public function new() {}
}
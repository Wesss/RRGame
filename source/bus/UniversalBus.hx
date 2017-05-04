package bus;

import domain.Displacement;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
class UniversalBus {

    public var controlsEvents(default, null):Bus<Displacement> = new Bus<Displacement>();

    public function new() {}
}
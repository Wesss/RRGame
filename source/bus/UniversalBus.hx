package bus;

import flixel.system.FlxSound;
import timing.BeatEvent;
import level.LevelEvent;
import domain.Displacement;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
class UniversalBus {
    // Add different bus as properties to this class. See below for an example
    // public var intEvents(default, null) = new Bus<Int>();

    public var controls(default, null) = new Bus<Displacement>();
    public var playerStartMove(default, null) = new Bus<Displacement>();
    public var playerMoved(default, null) = new Bus<Displacement>();
    public var beat(default, null):Bus<BeatEvent> = new Bus<BeatEvent>();
    public var level(default, null):Bus<LevelEvent> = new Bus<LevelEvent>();
    public var musicStart(default, null):Bus<FlxSound> = new Bus<FlxSound>();
    public var threatKillSquare(default, null) = new Bus<Displacement>();
    public var playerHit(default, null) = new Bus<Displacement>();
    public var playerHPChange(default, null) = new Bus<Int>();
    public var playerDie(default, null) = new Bus<Displacement>();
    public var levelOutOfBeats(default, null) = new Bus<Bool>(); // bool is placeholder
    public var gameOver(default, null) = new Bus<Int>();

    public function new() {}
}

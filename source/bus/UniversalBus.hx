package bus;

import level.ThreatLandedEvent;
import domain.Displacement;
import level.LevelLoadEvent;
import level.LevelStartEvent;
import timing.BeatEvent;
import timing.RewindLevelEvent;
import timing.RewindTimingEvent;

/**
 *  UniversalBus is a collection of different buses that are going to be used.
 *  The different buses are exposed via read-only properties of an instance of this class.
 */
class UniversalBus {
    // Add different bus as properties to this class. See below for an example
    // public var intEvents(default, null) = new Bus<Int>();

    public var levelLoad(default, null):Bus<LevelLoadEvent> = new Bus<LevelLoadEvent>();
    public var levelStart(default, null):Bus<LevelStartEvent> = new Bus<LevelStartEvent>();

    public var newControlDesire(default, null) = new Bus<Displacement>();
    public var controls(default, null) = new Bus<Displacement>();
    public var playerStartMove(default, null) = new Bus<Displacement>();
    public var playerMoved(default, null) = new Bus<Displacement>();

    public var musicLoaded(default, null):Bus<Bool> = new Bus<Bool>();
    public var musicPlayheadUpdate(default, null):Bus<Float> = new Bus<Float>();
    public var beat(default, null):Bus<BeatEvent> = new Bus<BeatEvent>();
    // rewind trigger should broadcast on this bus
    public var rewindLevel(default, null):Bus<RewindLevelEvent> = new Bus<RewindLevelEvent>();
    public var rewindTiming(default, null):Bus<RewindTimingEvent> = new Bus<RewindTimingEvent>(); // NOT this bus

    public var threatKillSquare(default, null) = new Bus<ThreatLandedEvent>();
    public var playerHit(default, null) = new Bus<ThreatLandedEvent>();
    public var playerHPChange(default, null) = new Bus<Int>();
    public var playerDie(default, null) = new Bus<Displacement>();
    public var levelOutOfBeats(default, null) = new Bus<Bool>(); // bool is placeholder
    public var gameOver(default, null) = new Bus<Int>();
    public var retry(default, null) = new Bus<Bool>();
    public var returnToHub(default, null) = new Bus<Bool>();
    public var triggerBeats(default, null) = new Bus<BeatEvent>();
    public var crateLanded(default, null) = new Bus<Displacement>();
    public var crateDestroyed(default, null) = new Bus<Displacement>();
    public var crateHit(default, null) = new Bus<Displacement>();
    public var healthLanded(default, null) = new Bus<Displacement>();
    public var healthDestroyed(default, null) = new Bus<Displacement>();
    public var healthHit(default, null) = new Bus<Displacement>();

    public var pause(default, null) = new Bus<Bool>();
    public var unpause(default, null) = new Bus<Bool>();

    public function new() {}
}

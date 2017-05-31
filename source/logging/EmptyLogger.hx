package logging;

import level.ThreatLandedEvent;
import bus.UniversalBus;
import domain.Displacement;
import timing.BeatEvent;

class EmptyLogger implements LoggingSystem {
    public function new() {}

    public function startLevel(level:Int, universalBus:UniversalBus, retry:Bool):Void {
        trace("Level " + level + " starting. Retry: " + retry);
        universalBus.newControlDesire.subscribe(this, logControlsInput);
        universalBus.rewindLevel.subscribe(this, traceEvent0);
        universalBus.rewindTiming.subscribe(this, traceEvent1);
    }

    private function updateBeat(event:BeatEvent):Void {}

    private function logControlsInput(event:Displacement):Void {
        trace(event);
    }

    private function logPlayerHit(event:ThreatLandedEvent):Void {}

    public function endLevel(score:Float):Void {}

    public function focusLost():Void {}

    public function focusGained():Void {}

    public function logABTestBuild(isBuildA:Bool):Void {}

    public function traceEvent0(event) {
        trace(event);
    }
    public function traceEvent1(event) {
        trace(event);
    }
    public function traceEvent2(event) {
        trace(event);
    }
}
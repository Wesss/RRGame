package logging;

import level.ThreatLandedEvent;
import bus.UniversalBus;
import domain.Displacement;
import timing.BeatEvent;

interface LoggingSystem {
    public function startLevel(level:Int, universalBus:UniversalBus, retry:Bool):Void;

    private function updateBeat(event:BeatEvent):Void;

    private function logControlsInput(event:Displacement):Void;

    private function logPlayerHit(event:ThreatLandedEvent):Void;

    public function endLevel(score:Float):Void;

    public function focusLost():Void;

    public function focusGained():Void;

    public function logABTestBuild(isBuildA:Bool):Void;
}
package logging;

import bus.UniversalBus;
import domain.Displacement;
import timing.BeatEvent;

class EmptyLogger implements LoggingSystem {
    public function new() {}

    public function startLevel(level:Int, universalBus:UniversalBus):Void {}

    private function updateBeat(event:BeatEvent):Void {}

    private function logControlsInput(event:Displacement):Void {}

    private function logPlayerHit(event:Displacement):Void {}

    public function endLevel(score:Float):Void {}

    public function focusLost():Void {}

    public function focusGained():Void {}
}
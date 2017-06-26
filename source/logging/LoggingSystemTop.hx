package logging;

import level.ThreatLandedEvent;
import timing.BeatEvent;
import domain.Displacement;
import bus.UniversalBus;

class LoggingSystemTop implements LoggingSystem {

    public function new() {
    }

    public function startLevel(level:Int, universalBus:UniversalBus, retry:Bool) {
    }

    private function updateBeat(event:BeatEvent) {
    }

    private function logControlsInput(event:Displacement) {
    }

    private function logPlayerHit(event:ThreatLandedEvent) {
    }

    private function logPlayerDie(event:Displacement) {
    }

    public function endLevel(score:Float) {
    }

    public function focusLost() {
    }

    public function focusGained() {
    }

    public function logABTestBuild(isBuildA : Bool) {
    };
}

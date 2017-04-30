package controls;

import bus.Bus;
import bus.UniversalBus;
import flixel.FlxBasic;

/**
 * The top level module, responsible for coordinating buses and recieving the update cycle
 **/
class ControlsSystemTop extends FlxBasic {

    private var controlsBus:Bus<ControlsInput>;
    private var controlsPoller:ControlsPoller;

    public function new(universalBus:UniversalBus) {
        super();
        controlsBus = universalBus.controlsEvents;
        controlsPoller = new ControlsPoller();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        controlsBus.broadcast(controlsPoller.getControlsInput());
    }
}

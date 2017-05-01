package controls;

import bus.Bus;
import bus.UniversalBus;
import domain.Displacement;
import flixel.FlxBasic;

/**
 * The top level module, responsible for coordinating buses and recieving the update cycle
 **/
class ControlsSystemTop extends FlxBasic {

    private var controlsBus:Bus<Displacement>;
    private var controlsPoller:ControlsPoller;
    private var previousPolledInput:Displacement;

    public function new(universalBus:UniversalBus) {
        super();
        controlsBus = universalBus.controlsEvents;
        controlsPoller = new ControlsPoller();
        previousPolledInput = null;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        var newPolledInput = controlsPoller.getControlsInput();
        if (!newPolledInput.equals(previousPolledInput)) {
            controlsBus.broadcast(newPolledInput);
            previousPolledInput = newPolledInput;
        }
    }
}

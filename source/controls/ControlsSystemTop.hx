package controls;

import bus.Bus;
import bus.UniversalBus;
import domain.Displacement;
import flixel.FlxBasic;
import flixel.FlxG;

/**
 * The top level module, responsible for coordinating buses and recieving the update cycle
 **/
class ControlsSystemTop extends FlxBasic {

    private var controlsBus:Bus<Displacement>;
    private var controlsPoller:ControlsPoller;
    private var previousPolledInput:Displacement;

    private var retryBus:Bus<Bool>;
    private var returnBus:Bus<Bool>;
    private var pauseBus:Bus<Bool>;

    public function new(universalBus:UniversalBus) {
        super();
        controlsBus = universalBus.newControlDesire;
        retryBus = universalBus.retry;
        returnBus = universalBus.returnToHub;
        pauseBus = universalBus.pause;
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

        if (FlxG.keys.justPressed.R) {
            retryBus.broadcast(true);
        }

        if (FlxG.keys.justPressed.SPACE) {
            returnBus.broadcast(true);
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            pauseBus.broadcast(true);
        }
    }
}

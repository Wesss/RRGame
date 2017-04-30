package controls;

import bus.UniversalBus;
import flixel.FlxBasic;

/**
 * The top level module, responsible for coordinating buses and recieving the update cycle
 **/
class ControlsSystemTop extends FlxBasic {
    public function new(universalBus:UniversalBus) {
        super();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}

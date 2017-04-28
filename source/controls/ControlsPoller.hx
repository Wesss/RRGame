package controls;
import domain.VerticalDisplacement;
import domain.HorizontalDisplacement;
import flixel.FlxG;

/**
 * Responsible for polling controller input via haxe flixel's interface
**/
class ControlsPoller {

    public function new() {

    }

    public function getMovementDirection():ControlsInput {
        // TODO
        return new ControlsInput(HorizontalDisplacement.NONE, VerticalDisplacement.NONE);
    }
}

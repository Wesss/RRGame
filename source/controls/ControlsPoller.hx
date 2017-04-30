package controls;
import domain.HorizontalDisplacement;
import domain.VerticalDisplacement;
import flixel.FlxG;

/**
 * Responsible for polling controller input via haxe flixel's interface
**/
class ControlsPoller {

    public function new() {

    }

    public function getMovementDirection():ControlsInput {
        var rightDisplacement = 0;
        var downDisplacement = 0;
        if (FlxG.keys.anyPressed([LEFT, A]))
        {
            rightDisplacement--;
        }
        if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            rightDisplacement++;
        }
        if (FlxG.keys.anyPressed([UP, W]))
        {
            downDisplacement--;
        }
        if (FlxG.keys.anyPressed([DOWN, S]))
        {
            downDisplacement++;
        }

        var horDisplacement = null;
        if (rightDisplacement == -1) {
            horDisplacement = HorizontalDisplacement.LEFT;
        } else if (rightDisplacement == 0) {
            horDisplacement = HorizontalDisplacement.NONE;
        } else if (rightDisplacement == 1) {
            horDisplacement = HorizontalDisplacement.RIGHT;
        }

        var verDisplacement = null;
        if (downDisplacement == -1) {
            verDisplacement = VerticalDisplacement.UP;
        } else if (downDisplacement == 0) {
            verDisplacement = VerticalDisplacement.NONE;
        } else if (downDisplacement == 1) {
            verDisplacement = VerticalDisplacement.DOWN;
        }

        return new ControlsInput(horDisplacement, verDisplacement);
    }
}

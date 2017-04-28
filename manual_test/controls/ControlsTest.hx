package;

import flixel.text.FlxText;
import controls.ControlsPoller;
import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class ControlsTest extends FlxState
{
    private var controlsPoller : ControlsPoller;
    private var outputText : FlxText;

    override public function create():Void
    {
        super.create();
        controlsPoller = new ControlsPoller();
        outputText = new flixel.text.FlxText(0, 0, 0, "No Update Recieved", 20);
        outputText.screenCenter();
        add(outputText);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        outputText.text = controlsPoller.getMovementDirection().toString();
    }
}

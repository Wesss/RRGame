package;

import bus.Bus.Receiver;
import bus.UniversalBus;
import controls.ControlsSystemTop;
import domain.Displacement;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class ControlsTest extends FlxState
{
    private var universalBus : UniversalBus;
    private var controlsSystemTop : ControlsSystemTop;

    override public function create():Void
    {
        super.create();
        universalBus = new UniversalBus();

        var outputText = new FlxText(0, 0, 0, "No Update Recieved", 20);
        outputText.screenCenter();
        add(outputText);

        controlsSystemTop = new ControlsSystemTop(universalBus);
        universalBus.controlsEvents.subscribe(new ControlsTest.TestControlsReceiver(outputText));
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        controlsSystemTop.update(elapsed);
    }
}

class TestControlsReceiver implements Receiver<Displacement> {

    private var outputText:FlxText;

    public function new(outputText:FlxText) {
        this.outputText = outputText;
    }

    public function receive(event : Displacement) {
        trace(event);
        outputText.text = event.toString();
    }
}

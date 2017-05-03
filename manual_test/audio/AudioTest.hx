package;

import domain.Displacement;
import flixel.FlxG;
import flixel.text.FlxText;
import audio.AudioSystemTop;
import bus.UniversalBus;
import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class AudioTest extends FlxState {

	private var universalBus : UniversalBus;
	private var audioSystemTop : AudioSystemTop;

	override public function create():Void
	{
		super.create();
		universalBus = new UniversalBus();

		audioSystemTop = new AudioSystemTop(universalBus);

		var outputText = new FlxText(0, 0, 0, "Press A to play player move sound-effect", 20);
		outputText.screenCenter();
		add(outputText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A])) {
			universalBus.controlsEvents.broadcast(new Displacement(NONE, NONE));
		}
	}
}

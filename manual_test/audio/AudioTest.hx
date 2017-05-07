package;

import level.LevelData;
import level.LevelEvent;
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
	private var mockLevelData : LevelData;

	override public function create():Void
	{
		super.create();
		universalBus = new UniversalBus();

		audioSystemTop = new AudioSystemTop(universalBus);

		mockLevelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, null, null, null);

		var message = "Press A to play player move sound-effect\n" +
		"Press L to load level music\n" +
		"Press M to play level music";
		var outputText = new FlxText(0, 0, 0, message, 20);
		outputText.screenCenter();
		add(outputText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A])) {
			universalBus.controlsEvents.broadcast(new Displacement(NONE, NONE));
		}
		if (FlxG.keys.anyJustPressed([L])) {
			universalBus.levelEvents.broadcast(new LevelEvent(LOAD, mockLevelData));
		}
		if (FlxG.keys.anyJustPressed([M])) {
			universalBus.levelEvents.broadcast(new LevelEvent(START, mockLevelData));
		}
	}
}

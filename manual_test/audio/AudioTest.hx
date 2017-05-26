package;

import level.LevelStartEvent;
import level.LevelLoadEvent;
import level.LevelData;
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

		mockLevelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, "", "", "", null, null, null);

		var message = "Press A to play player hit sound-effect\n" +
		"Press L to load level music\n" +
		"Press M to play level music";
		var outputText = new FlxText(0, 0, 0, message, 20);
		outputText.screenCenter();
		add(outputText);
		add(audioSystemTop);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A])) {
			universalBus.playerHit.broadcast(new Displacement(NONE, NONE));
		}
		if (FlxG.keys.anyJustPressed([L])) {
			universalBus.levelLoad.broadcast(new LevelLoadEvent(mockLevelData));
		}
		if (FlxG.keys.anyJustPressed([M])) {
			universalBus.levelStart.broadcast(new LevelStartEvent(mockLevelData, 0));
		}
	}
}

package;

import logging.EmptyLogger;
import level.LevelDataLoader;
import bus.UniversalBus;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxState;

/**
 * A manual test for playing through an actual level
**/
class RunActualLevelTest extends FlxState {

	// change this to change the level run
	private static inline var LEVEL_ASSET_PATH = "assets/levels/level4.oel";

	override public function create():Void {
		super.create();
		var universalBus = new UniversalBus();
		var levelData = LevelDataLoader.loadLevelData(LEVEL_ASSET_PATH, universalBus);

		FlxG.switchState(new PlayLevelState(levelData, -1, universalBus, new EmptyLogger()));
	}
}

package;

import logging.EmptyLogger;
import persistent_state.LocalStorageManager;
import flixel.FlxG;
import hubworld.HubWorldState;
import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class HubworldTest extends FlxState {

	override public function create():Void {

		var levelScores = new Map<Int, Float>();
		// Add level scores here to load into hubworld with said data
//		levelScores.set(0, 4);
//		levelScores.set(1, 3);
//		levelScores.set(3, 3);

		LocalStorageManager.initializePersistentState(new EmptyLogger());
		LocalStorageManager.saveProgress(levelScores);

		FlxG.switchState(new HubWorldState(null, {
			level: 0,
			score: 2
		}));
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}

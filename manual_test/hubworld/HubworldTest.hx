package;

import persistent_state.SaveManager;
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
		// ie. levelScores.set(0, 4);
		levelScores.set(0, 2);
//		levelScores.set(1, 3);
//		levelScores.set(3, 3);


		SaveManager.initializeSaveData();
		SaveManager.saveProgress(levelScores);

		FlxG.switchState(new HubWorldState(null, {
			level: 2,
			score: 4
		}));
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}

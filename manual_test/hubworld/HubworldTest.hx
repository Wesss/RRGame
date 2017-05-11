package;

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
		levelScores.set(0, 4);

		FlxG.save.data.initialized = true;
		FlxG.save.data.levelScore = levelScores;
		FlxG.save.flush();

		FlxG.switchState(new HubWorldState(null, {
			level: 1,
			score: 2
		}));
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}

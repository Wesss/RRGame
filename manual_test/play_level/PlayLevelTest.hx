package;

import level.LevelData;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxState;

/**
 * A manual test for verifying level playing functionality
**/
class PlayLevelTest extends FlxState
{
	override public function create():Void
	{
		super.create();
		// TODO create level data and pass in to run the level
		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, 135, 444, null);
		FlxG.switchState(new PlayLevelState(levelData));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

package;

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
		FlxG.switchState(new PlayLevelState(null));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

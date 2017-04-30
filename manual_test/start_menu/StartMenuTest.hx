package;

import start_menu.StartMenuState;
import flixel.FlxG;
import flixel.FlxState;

/**
 * A manual test for verifying start menu functionality
**/
class StartMenuTest extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.switchState(new StartMenuState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

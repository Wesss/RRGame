package;

import hubworld.HubWorldState;
import flixel.FlxG;
import flixel.FlxState;

/**
 * A manual test for verifying level playing functionality
**/
class ScoreAnimation extends FlxState
{
	override public function create():Void
	{
		super.create();

		var universalBus = new bus.UniversalBus();
		FlxG.switchState(new HubWorldState(null, {level : 0, score : 4}));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

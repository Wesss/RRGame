package;

import domain.*;
import level.LevelData;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;

/**
 * A manual test for verifying level playing functionality
**/
class PlayLevelTest extends FlxState
{
	override public function create():Void
	{
		super.create();
		// TODO create level data and pass in to run the level

		var universalBus = new bus.UniversalBus();
		// Create sample level data
		var trackGroup = new FlxSpriteGroup();
		var slider = new track_action.SliderThreat(10, 135, new Displacement(HorizontalDisplacement.RIGHT, VerticalDisplacement.DOWN), universalBus);
		trackGroup.add(slider);
		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, 135, 444, [slider]);
		
		FlxG.switchState(new PlayLevelState(levelData, trackGroup, universalBus));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

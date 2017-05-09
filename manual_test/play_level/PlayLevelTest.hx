package;

import domain.*;
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

		var universalBus = new bus.UniversalBus();

		// Create sample level data
		var bpm = 135;
		var threats : Array<track_action.TrackAction> = [];
		
		var i = 10;
		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus);
				threats.push(slider);
				i++;
			}
		}

		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus);
				threats.push(slider);
			}
			i++;
		}

		
		for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
			for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
				var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus);
				threats.push(slider);
			}
			i++;
		}

		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, bpm, 444, threats);

		FlxG.switchState(new PlayLevelState(levelData, -1, universalBus, null));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

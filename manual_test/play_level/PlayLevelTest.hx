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
		
		var i = 2;
		var warn = 2;
		for (x in 0...5) {
			var slider = new track_action.SliderThreat(i, bpm, new Displacement(NONE, NONE), universalBus, warn);
			threats.push(slider);
			i += 1;
		}

		/*
		i += 9;
		
		for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
			for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
				var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
				threats.push(slider);
			}
			i++;
		}

		i += 9;

		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
				threats.push(slider);
				i++;
			}
		}

		i += 9;

		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				if (!horizontalDisplacement.equals(HorizontalDisplacement.NONE) ||
					!verticalDisplacement.equals(VerticalDisplacement.NONE)) {
					var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
					threats.push(slider);
				}
			}
		}

		i += 2;
		var slider = new track_action.SliderThreat(i, bpm, new Displacement(HorizontalDisplacement.NONE, VerticalDisplacement.NONE), universalBus, warn);
		threats.push(slider);

		i += 2;

		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				if (!horizontalDisplacement.equals(HorizontalDisplacement.NONE) ||
					!verticalDisplacement.equals(VerticalDisplacement.NONE)) {
					var slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
					threats.push(slider);
				}
			}
		}

		i += 2;
		slider = new track_action.SliderThreat(i, bpm, new Displacement(HorizontalDisplacement.NONE, VerticalDisplacement.NONE), universalBus, warn);
		threats.push(slider);

		i += 2;
		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				if (horizontalDisplacement.equals(HorizontalDisplacement.NONE) ||
					verticalDisplacement.equals(VerticalDisplacement.NONE)) {
					slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
					threats.push(slider);
				}
			}
		}

		i += 2;
		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				if (!horizontalDisplacement.equals(HorizontalDisplacement.NONE) &&
					!verticalDisplacement.equals(VerticalDisplacement.NONE)) {
					slider = new track_action.SliderThreat(i, bpm, new Displacement(horizontalDisplacement, verticalDisplacement), universalBus, warn);
					threats.push(slider);
				}
			}
		}
		slider = new track_action.SliderThreat(i, bpm, new Displacement(HorizontalDisplacement.NONE, VerticalDisplacement.NONE), universalBus, warn);
		threats.push(slider);*/

		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, bpm, 444, threats);
		FlxG.switchState(new PlayLevelState(levelData, 0, universalBus, null));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

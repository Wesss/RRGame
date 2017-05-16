package;

import logging.EmptyLogger;
import timing.TimingSystemTop;
import timing.TimingSystemTop;
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
		threats.push(new track_action.Crate(2, bpm, new Displacement(NONE, DOWN), universalBus, warn, 32));

		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, bpm, 444, threats);
		trace(TimingSystemTop.MILISECONDS_PER_MINUTE / levelData.bpm);
		FlxG.switchState(new PlayLevelState(levelData, 0, universalBus, new EmptyLogger()));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

package;

import logging.EmptyLogger;
import timing.TimingSystemTop;
import domain.*;
import level.LevelData;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxState;
import track_action.*;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class RewindTest extends FlxState
{
	override public function create():Void
	{
		super.create();

		var universalBus = new bus.UniversalBus();

		// Create sample level data
		var bpm = 135;
		var threats : Array<track_action.TrackAction> = [];

		threats.push(new RewindSliderThreat(8, bpm, new Displacement(LEFT, NONE), universalBus, 2, 4));
		threats.push(new RewindSliderThreat(12, bpm, new Displacement(RIGHT, NONE), universalBus, 2, 8));
		threats.push(new RewindSliderThreat(16, bpm, new Displacement(NONE, NONE), universalBus, 2, 3));
		threats.push(new HealthPickupTutorial(20, new Displacement(LEFT, DOWN), universalBus));
		threats.push(new SliderThreat(24, bpm, new Displacement(RIGHT, DOWN), universalBus, 2));

		var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, "", "", "", bpm, 444, threats);
		trace(TimingSystemTop.MILISECONDS_PER_MINUTE / levelData.bpm);
		var logger = new EmptyLogger();
		logger.startLevel(0, universalBus, false);
		FlxG.switchState(new PlayLevelState(levelData, 0, universalBus, logger));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

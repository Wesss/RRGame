package;

import logging.EmptyLogger;
import level.LevelDataLoader;
import level.LevelData;
import bus.UniversalBus;
import level.PlayLevelState;
import flixel.FlxG;
import flixel.FlxState;
import track_action.*;
import bus.*;
import domain.*;

/**
 * A manual test for calculating an estimate apm for a level
**/
class EstimateApm extends FlxState {
	private static inline var LEVEL_ASSET_PREFIX = "assets/levels/level";

	override public function create():Void {
		super.create();
		var results = "";
		results += "\nLevel\tAverage APM\tEstimated Winrate";
		for (i in 1...5) {
			var universalBus = new UniversalBus();
			var levelData = LevelDataLoader.loadLevelData(LEVEL_ASSET_PREFIX + i + ".oel", universalBus);
			var simulator = new Simulator(levelData);
			var levelName : String;
			if (i > 4) {
				levelName = "2-" + (i - 4);
			} else {
				levelName = "1-" + (i + 1);
			}
			var apm = simulator.getAverageAPM();
			var winrate = -0.0094 * apm + 1.0396;
			results += "\n" + levelName + "\t" + apm + "\t" + winrate;
		}
		trace(results);
	}
}

class Simulator {
	private static inline var SAMPLES = 100;

	private var levelData : LevelData;

	public function new(levelData : LevelData) {
		this.levelData = levelData;
	}

	public function getAverageAPM() : Float {
		var actions = levelData.trackActions;
		actions.sort(function (a, b) : Int {
			if (a.beatOffset < b.beatOffset) {
				return -1;
			} else if (a.beatOffset > b.beatOffset) {
				return 1;
			}
			return 0;
		});
		
		var movements = 0;
		for (i in 0...SAMPLES) {
			var playerPosition = new Displacement(NONE, NONE);
			var idx = 0;
			while (idx < actions.length) {
				var beat = actions[idx].beatOffset;
				var freeSquares = new FreeSquares();

				while (idx < actions.length && actions[idx].beatOffset == beat) {
					var name = Type.getClassName(Type.getClass(actions[idx]));
					switch (name) {
						case "track_action.SliderThreat": freeSquares.remove((cast (actions[idx], SliderThreat)).position);
						case "track_action.SliderThreatHoming": freeSquares.remove(playerPosition);
						default: //trace("Undealt action: " + name);
					}
					idx++;
				}

				var isPlayerOnFreeSquare = freeSquares.contains(playerPosition);
				if (!isPlayerOnFreeSquare) {
					playerPosition = freeSquares.getRandom();
					movements++;
				}
			}
		}

		var averageMovements = movements / SAMPLES;
		var levelTime = actions[actions.length - 1].beatOffset / levelData.bpm;
		//trace("LT: " + levelTime + ", last beat offset: " + actions[actions.length - 1].beatOffset);
		var averageAPM = averageMovements / levelTime;
		return averageAPM;
	}
}

class FreeSquares {
	var freeSquares : Array<Displacement>;
	public function new() {
		freeSquares = [];
		for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
			for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
				freeSquares.push(new Displacement(horizontalDisplacement, verticalDisplacement));
			}
		}
	}

	public function remove(d : Displacement) {
		for (square in freeSquares) {
			if (square.equals(d)) {
				freeSquares.remove(square);
				return;
			}
		}
	}

	public function contains(d : Displacement) : Bool {
		for (square in freeSquares) {
			if (square.equals(d)) {
				return true;
			}
		}
		return false;
	}

	public function getRandom() : Displacement {
		return freeSquares[Std.random(freeSquares.length)];
	}
}
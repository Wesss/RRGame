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
import StringTools.*;

/**
 * A manual test for calculating an estimate apm for a level
**/
class EstimateApm extends FlxState {
	private static inline var LEVEL_ASSET_PREFIX = "assets/levels/level";

	override public function create():Void {
		super.create();
		var results = "";
		results += "\nLevel\t" + StringTools.lpad("Average APM", " ", 22) + "\tEstimated Winrate";
		for (i in 1...10) {
			var universalBus = new UniversalBus();
			var levelData = LevelDataLoader.loadLevelData(LEVEL_ASSET_PREFIX + i + ".oel", universalBus);
			var simulator = new Simulator(levelData);
			var levelName : String;
			if (i > 4) {
				levelName = "2-" + (i - 4) + "   ";
			} else {
				levelName = "1-" + (i + 1) + "   ";
			}
			var apm = simulator.getAverageAPM();
			var winrate = 1.46596840643475 - 0.0123460886558799 * apm - 0.212562881543819 * simulator.getLevelTime();
			var apmString = StringTools.lpad("" + apm, " ", 22);
			results += "\n" + levelName + "\t" + apmString + "\t" + winrate;
		}
		trace(results);
	}
}

class Simulator {
	private static inline var SAMPLES = 100;
	private static inline var RESOLUTION = 3;

	private var levelData : LevelData;
	private var actions : Array<TrackAction>;

	public function new(levelData : LevelData) {
		this.levelData = levelData;
		actions = levelData.trackActions;
		actions.sort(function (a, b) : Int {
			if (a.beatOffset < b.beatOffset) {
				return -1;
			} else if (a.beatOffset > b.beatOffset) {
				return 1;
			}
			return 0;
		});
	}

	public function getAverageAPM() : Float {
		var movements = 0;
		for (i in 0...SAMPLES) {
			simulate(function(beat) {
				movements++;
			});
		}

		var averageMovements = movements / SAMPLES;
		var levelTime = getLevelTime();
		var averageAPM = averageMovements / levelTime;
		return averageAPM;
	}

	public function getLevelTime() : Float {
		return actions[actions.length - 1].beatOffset / levelData.bpm;
	}

	public function getMaximumAPMInWindow(windowDurationSeconds : Float) : Array<Float> {
		var apmSums : Array<Float>;
		apmSums = null;
		var levelTime = actions[actions.length - 1].beatOffset / levelData.bpm;

		for (sample in 0...SAMPLES) {
			var beatsMoved : Array<Float>;
			beatsMoved = [];
			simulate(function(beat) {
				beatsMoved.push(beat);
			});

			// search biggest apm in 5 second window
			var allApms = [];
			var startTime = 0; // in seconds

			while (startTime < levelTime * 60) {
				var startBeat = (startTime / 60) * levelData.bpm;
				var endBeat = startBeat + (windowDurationSeconds / 60) * levelData.bpm;

				var movementsInWindow = 0;

				// get i to be the first recorded beat past the start
				var i = 0;
				while (i < beatsMoved.length && beatsMoved[i] < startBeat) {
					i++;
				}

				// scan across all beats moved until we reach the end beat
				while (i < beatsMoved.length && beatsMoved[i] <= endBeat) {
					movementsInWindow++;
					i++;
				}

				var apm = movementsInWindow / (windowDurationSeconds / 60);
				allApms.push(apm);

				startTime += RESOLUTION;
			}

			if (apmSums == null) {
				apmSums = allApms;
			} else {
				for (i in 0...apmSums.length) {
					apmSums[i] += allApms[i];
				}
			}
		}

		for (i in 0...apmSums.length) {
			apmSums[i] = apmSums[i] / SAMPLES;
		}

		return apmSums;
	}

	private function simulate(onPlayerMove : Float -> Void) {
		var playerPosition = new Displacement(NONE, NONE);
		var idx = 0;
		var crates : Array<AbstractCrate>;
		crates = [];
		while (idx < actions.length) {
			var beat = actions[idx].beatOffset;

			// remove expired crates
			var i = crates.length - 1;
			while (i >= 0) {
				if (crates[i].beatExpire >= beat) {
					crates.splice(i, 1);
				}
				i--;
			}

			// calculate free squares given crates
			var freeSquares = new FreeSquares();
			for (crate in crates) {
				freeSquares.remove(crate.position);
			}

			// process all threats during this beat, removing free squares as necessary
			while (idx < actions.length && actions[idx].beatOffset == beat) {
				var name = Type.getClassName(Type.getClass(actions[idx]));
				switch (name) {
					case "track_action.SliderThreat": freeSquares.remove((cast (actions[idx], SliderThreat)).position);
					case "track_action.SliderThreatHoming": freeSquares.remove(playerPosition);
					case "track_action.Crate":
						var position = (cast (actions[idx], SliderThreat)).position;
						freeSquares.remove(position);
						crates.push(new AbstractCrate(position, actions[idx].triggerBeats[actions[idx].triggerBeats.length - 1]));
					default: //trace("Undealt action: " + name);
				}
				idx++;
			}

			var isPlayerOnFreeSquare = freeSquares.contains(playerPosition);
			if (!isPlayerOnFreeSquare) {
				playerPosition = freeSquares.getRandom();
				onPlayerMove(beat);
			}
		}
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

class AbstractCrate {
	public var position : Displacement;
	public var beatExpire : Float;

	public function new (position : Displacement, beatExpire : Float) {
		this.position = position;
		this.beatExpire = beatExpire;
	}
}
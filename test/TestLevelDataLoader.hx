package ;

import bus.UniversalBus;
import domain.Displacement;
import flixel.math.FlxMath;
import track_action.SliderThreat;
import level.LevelDataLoader;
import massive.munit.Assert;

class TestLevelDataLoader {

	public function new() {
		
	}

	@Test
	public function metaLevelDataIsLoadedCorrectly():Void {
		var levelData = LevelDataLoader.loadLevelData(AssetPaths.testLevel__oel, new UniversalBus());

		Assert.isTrue(levelData != null);

		Assert.isTrue(levelData.musicTrack == AssetPaths.testTrack__ogg);
		Assert.isTrue(levelData.bpm == 135);
		Assert.isTrue(levelData.songStartOffsetMilis == 444);
	}

	@Test
	public function trackActionLevelDataIsLoadedCorrectly():Void {
		var levelData = LevelDataLoader.loadLevelData(AssetPaths.testLevel__oel, new UniversalBus());
		Assert.isTrue(levelData != null);
		var trackActions = levelData.trackActions;

		// convert to instantiated types
		var sliderThreats = new Array<SliderThreat>();
		for (trackAction in trackActions) {
			if (Std.is(trackAction, SliderThreat)) {
				sliderThreats.push(cast trackAction);
			} else {
				throw "Track Action of Unknown Type Given";
			}
		}

		// generate expectation
		var expectedSliderThreats = new Array<Dynamic>();
		expectedSliderThreats.push(getExpectedSliderThreat(0.0, new Displacement(LEFT, UP)));
		expectedSliderThreats.push(getExpectedSliderThreat(4.0, new Displacement(LEFT, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(8.0, new Displacement(LEFT, DOWN)));
		expectedSliderThreats.push(getExpectedSliderThreat(12.0, new Displacement(NONE, UP)));
		expectedSliderThreats.push(getExpectedSliderThreat(12.5, new Displacement(RIGHT, UP)));
		expectedSliderThreats.push(getExpectedSliderThreat(13.0, new Displacement(RIGHT, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(13.5, new Displacement(NONE, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(14.0, new Displacement(NONE, DOWN)));
		expectedSliderThreats.push(getExpectedSliderThreat(14.5, new Displacement(RIGHT, DOWN)));
		expectedSliderThreats.push(getExpectedSliderThreat(15.0, new Displacement(RIGHT, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(15.5, new Displacement(NONE, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(16.0, new Displacement(LEFT, UP)));
		expectedSliderThreats.push(getExpectedSliderThreat(16.0, new Displacement(LEFT, NONE)));
		expectedSliderThreats.push(getExpectedSliderThreat(16.0, new Displacement(LEFT, DOWN)));

		// test
		for (sliderThreat in sliderThreats) {
			var isSliderExpected = checkForAndRemoveExpectedSliderThread(sliderThreat, expectedSliderThreats);
			Assert.isTrue(isSliderExpected);
		}
		Assert.isTrue(expectedSliderThreats.length == 0);
	}

	/**
	 * Returns an anonymous structure with info given
     **/
	private function getExpectedSliderThreat(beatOffset:Float, position:Displacement) {
		// TODO construct displacement positions and check for those
		return {beatOffset: beatOffset, position: position};
		//beatOffset : Float, bpm : Int, position : Displacement, universalBus : UniversalBus, beatWarnTime = 2.0) {
	}

	/**
	 * If given track action is represented by an expected action in given array, then matching expected
	 * action is removed from the given array and true is returned.
	 * Otherwise false is returned.
     **/
	private function checkForAndRemoveExpectedSliderThread(sliderThreat:SliderThreat,
														   expectedSliderThreats:Array<Dynamic>):Bool {
		for (expectedSliderThreat in expectedSliderThreats) {
			if (nearlyEqual(sliderThreat.beatOffset, expectedSliderThreat.beatOffset) &&
					sliderThreat.position.equals(expectedSliderThreat.position)) {
				expectedSliderThreats.remove(expectedSliderThreat);
				return true;
			}
		}
		return false;
	}

	/**
	 * compares for almost equality between floats.
	 * Copied from http://stackoverflow.com/questions/4915462/how-should-i-do-floating-point-comparison
     **/
	private static function nearlyEqual(a:Float, b:Float):Bool {
		var epsilon = 0.001;
		var absA = Math.abs(a);
		var absB = Math.abs(b);
		var diff = Math.abs(a - b);

		if (a == b) { // shortcut, handles infinities
			return true;
		} else if (a == 0 || b == 0 || diff < FlxMath.MIN_VALUE_FLOAT) {
			// a or b is zero or both are extremely close to it
			// relative error is less meaningful here
			return diff < (epsilon * FlxMath.MIN_VALUE_FLOAT);
		} else { // use relative error
			return diff / (absA + absB) < epsilon;
		}
	}
}
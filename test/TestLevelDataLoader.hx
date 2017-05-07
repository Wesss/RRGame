package ;

import level.LevelDataLoader;
import massive.munit.Assert;

class TestLevelDataLoader {

	public function new() {
		
	}

	@Test
	public function metaLevelDataIsLoadedCorrectly():Void {
		var levelData = LevelDataLoader.loadLevelData(AssetPaths.testLevel__oel);

		Assert.isTrue(levelData != null);

		Assert.isTrue(levelData.musicTrack == AssetPaths.testTrack__ogg);
		Assert.isTrue(levelData.bpm == 135);
		Assert.isTrue(levelData.songStartOffsetMilis == 444);
		// TODO assert trackaction array correctness
	}
}
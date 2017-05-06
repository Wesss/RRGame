package ;

import level.LevelDataLoader;
import massive.munit.Assert;

class TestLevelDataLoader {

	public function new() {
		
	}
	
	@Before
	public function setup():Void {

	}

	@After
	public function tearDown():Void {

	}

	@Test
	public function testExample():Void {
		var levelData = LevelDataLoader.loadLevelData(AssetPaths.testLevel__oel);

		// TODO test levelData more thoroughly
		Assert.isTrue(levelData != null);
	}
}
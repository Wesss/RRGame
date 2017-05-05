package level;

import audio.AudioSystemTop;
import bus.UniversalBus;
import flixel.FlxState;

class PlayLevelState extends FlxState
{
	private var levelData:LevelData;

	public function new(levelData:LevelData) {
		super();
		this.levelData = levelData;
	}

	override public function create():Void
	{
		super.create();
		var universalBus = new UniversalBus();

		// TODO hook up movement, board & player, timing subsystems

		var levelRunner = new LevelRunner(universalBus);
		var audioSystemTop = new AudioSystemTop(universalBus);

		levelRunner.runLevel(levelData);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

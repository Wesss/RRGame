package level;

import audio.AudioSystemTop;
import bus.UniversalBus;
import board.BoardSystemTop;
import controls.ControlsSystemTop;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import timing.TimingSystemTop;

class PlayLevelState extends FlxState {
	private var levelData:LevelData;
	private var timingSystemTop:TimingSystemTop;

	public function new(levelData:LevelData) {
		super();
		this.levelData = levelData;
	}

	override public function create():Void {
		super.create();

		var universalBus = new bus.UniversalBus();

		// System initialization
		new AudioSystemTop(universalBus);
		add(new ControlsSystemTop(universalBus));
		add(new BoardSystemTop(0, 0, universalBus));
		timingSystemTop = new TimingSystemTop(universalBus);
		add(timingSystemTop);

		var levelRunner = new LevelRunner(universalBus);

		// Camera and camera shake
		FlxG.camera.focusOn(new FlxPoint(0, 0));
	 	universalBus.playerMoved.subscribe(this, function(displacement) {FlxG.camera.shake(0.01, 0.1);});
		
		levelRunner.runLevel(levelData);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onFocus() {
//		timingSystemTop.onPause();
	}

	override public function onFocusLost() {
//		timingSystemTop.onResume();
	}
}

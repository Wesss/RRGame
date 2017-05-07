package level;

import audio.AudioSystemTop;
import bus.UniversalBus;
import board.BoardSystemTop;
import controls.ControlsSystemTop;
import domain.Displacement;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import timing.TimingSystemTop;

class PlayLevelState extends FlxState {
	private var levelData:LevelData;
	private var timingSystemTop:TimingSystemTop;
	private var trackGroup:FlxSpriteGroup;
	private var universalBus:UniversalBus;

	public function new(levelData:LevelData, trackGroup:FlxSpriteGroup, universalBus:UniversalBus) {
		super();
		this.levelData = levelData;
		this.trackGroup = trackGroup;
		this.universalBus = universalBus;
	}

	override public function create():Void {
		super.create();
		FlxG.mouse.visible = false;

		// System initialization
		new Referee(universalBus);
		new AudioSystemTop(universalBus);
		add(new ControlsSystemTop(universalBus));
		add(new BoardSystemTop(0, 0, universalBus));
		timingSystemTop = new TimingSystemTop(universalBus);
		add(timingSystemTop);
		add(trackGroup);

		var levelRunner = new LevelRunner(universalBus);

		// Camera and camera shake
		FlxG.camera.focusOn(new FlxPoint(0, 0));
		universalBus.playerMoved.subscribe(this, function(displacement) {
			FlxG.camera.shake(0.01, 0.1);
		});

	 	universalBus.threatKillSquare.subscribe(this, function(displacement) {
			FlxG.camera.shake(0.05, 0.2);
		});

		universalBus.playerHPChange.subscribe(this, function(newHP) {
			FlxG.camera.flash(flixel.util.FlxColor.WHITE, 0.1);
			FlxG.camera.shake(0.01, 0.1);
		});
		
		universalBus.playerDie.subscribe(this, handlePlayerDie);

		levelRunner.runLevel(levelData);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function handlePlayerDie(whereTheyDied : Displacement) {
		
	}
}

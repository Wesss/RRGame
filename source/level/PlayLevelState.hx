package level;

import audio.AudioSystemTop;
import bus.UniversalBus;
import board.BoardSystemTop;
import board.Player;
import controls.ControlsSystemTop;
import domain.Displacement;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.*;
import flixel.group.FlxSpriteGroup;
import hubworld.HubWorldState;
import timing.TimingSystemTop;

class PlayLevelState extends FlxState {
	private var levelData:LevelData;
	private var levelIndex:Int;
	private var timingSystemTop:TimingSystemTop;
	private var trackGroup:FlxSpriteGroup;
	private var universalBus:UniversalBus;

	private var player:Player;

	public function new(levelData:LevelData, levelIndex:Int, universalBus:UniversalBus) {
		super();
		this.levelData = levelData;
		this.levelIndex = levelIndex;
		this.trackGroup = new FlxSpriteGroup();
		for (trackAction in levelData.trackActions) {
			if (Std.is(trackAction, FlxSprite)) {
				this.trackGroup.add(cast(trackAction, FlxSprite));
			}
		}
		this.universalBus = universalBus;
	}

	override public function create():Void {
		super.create();
		FlxG.mouse.visible = false;

		// System initialization
		new Referee(universalBus);
		new AudioSystemTop(universalBus);
		add(new ControlsSystemTop(universalBus));
		var board = new BoardSystemTop(0, 0, universalBus);
		add(board);
		player = board.player;
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
			FlxG.camera.shake(0.02, 0.2);
		});

		universalBus.playerHPChange.subscribe(this, function(newHP) {
			FlxG.camera.flash(flixel.util.FlxColor.WHITE, 0.1);
			FlxG.camera.shake(0.01, 0.1);
		});
		
		universalBus.playerDie.subscribe(this, handlePlayerDie);
        universalBus.levelOutOfBeats.subscribe(this, handleOutOfBeats);

		levelRunner.runLevel(levelData);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function handlePlayerDie(whereTheyDied : Displacement) {
		universalBus.gameOver.broadcast(0);
		trackGroup.alpha = 0;
		
		var message = new BeatText(universalBus, "You lose!", 50, 1.1);
		message.x = -message.width / 2;
		message.y = -120;
		add(message);

		var instructions = new BeatText(universalBus, "[ Press R to retry ] [ Press Space to return to Level Select ]", 20, 1.05);
		instructions.x = -instructions.width / 2;
		instructions.y = 60;
		add(instructions);

		setupFinishControls();
	}

	public function handleOutOfBeats(_) {
		universalBus.gameOver.broadcast(player.hp);
		trackGroup.alpha = 0;

		var message = new BeatText(universalBus, "You win!", 50, 1.1);
		message.x = -message.width / 2;
		message.y = -120;
		add(message);

		var stats = new BeatText(universalBus, "HP Left:" + player.hp, 30, 1.1);
		stats.y = -stats.height / 2;
		add(stats);

		var instructions = new BeatText(universalBus, "[ Press R to retry ] [ Press Space to return to Level Select ]", 20, 1.05);
		instructions.x = -instructions.width / 2;
		instructions.y = 60;
		add(instructions);

		setupFinishControls();
	}

	private function setupFinishControls() {
		universalBus.retry.subscribe(this, function(_) {
			FlxG.switchState(new HubWorldState({
				level: levelIndex,
				score: player.hp
			}, true));
		});

		universalBus.returnToHub.subscribe(this, function(_) {
			FlxG.switchState(new HubWorldState({
				level: levelIndex,
				score: player.hp
			}));
		});
	}
}

private class BeatText extends FlxText {
	var oldBeat : Float;
	public function new(universalBus : UniversalBus, text : String, size : Int, beatScale : Float) {
		super(0, 0, 0, text);
		setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.WHITE, CENTER);

		oldBeat = 0.0;

		universalBus.beat.subscribe(this, function(beat) {
			if (Math.round(oldBeat) >= oldBeat && Math.round(beat.beat) <= beat.beat) {
				scale.x = beatScale;
				scale.y = beatScale;

				FlxTween.tween(scale, {
					x : 1.0,
					y : 1.0
				}, 0.2, {
					ease : FlxEase.quadOut
				});
			}
			oldBeat = beat.beat;
		});
	}
}
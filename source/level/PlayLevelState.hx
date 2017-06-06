package level;

import pause_options_menu.PauseOptionsMenu;
import logging.LoggingSystem;
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
	private var trackGroup:FlxSpriteGroup;
	private var userInterfaceGroup:FlxSpriteGroup;
	private var juiceGroup:FlxSpriteGroup;
	private var universalBus:UniversalBus;
	private var logger:LoggingSystem;
	private var player:Player;

	public function new(levelData:LevelData,
						levelIndex:Int,
						universalBus:UniversalBus,
						logger:LoggingSystem) {
		super();
		this.levelData = levelData;
		this.levelIndex = levelIndex;
		this.trackGroup = new FlxSpriteGroup();
		for (trackAction in levelData.trackActions) {
			if (Std.is(trackAction, FlxSprite)) {
				this.trackGroup.add(cast(trackAction, FlxSprite));
			}
		}
		this.userInterfaceGroup = new FlxSpriteGroup();
		this.juiceGroup = new FlxSpriteGroup();
		this.universalBus = universalBus;
		this.logger = logger;
	}

	override public function create():Void {
		super.create();
		FlxG.mouse.visible = false;

		// System initialization
		new Referee(universalBus, levelData.bpm);
		add(new AudioSystemTop(universalBus));
		add(new ControlsSystemTop(universalBus));
		var board = new BoardSystemTop(0, 0, universalBus);
		add(board);
		player = board.player;
		add(new TimingSystemTop(universalBus));
		userInterfaceGroup.add(new ProgressBar(universalBus));
		add(trackGroup);
		add(userInterfaceGroup);
		Juicer.juiceLevel(universalBus, juiceGroup);
		add(juiceGroup);
		var levelRunner = new LevelRunner(universalBus);

		add(new ScreenBanner(universalBus, "Bringing the music", 20));

		// Rewind indicators
		universalBus.sliderRewindHit.subscribe(this, function(e) {
			var rewindIndicator = new RewindIndicator();
			FlxTween.globalManager.active = false;

			rewindIndicator.closeCallback = function() {
				universalBus.unpause.broadcast(true);
				FlxTween.globalManager.active = true;
				
				// Restore pause and unpause menu
				universalBus.pause.subscribe(this, pauseGame);
				universalBus.unpause.subscribe(this, unpauseGame);
			}

			universalBus.rewindLevel.broadcast(e);
			openSubState(rewindIndicator);
		});


		// Camera
		FlxG.camera.focusOn(new FlxPoint(0, 0));

		// Pause
		var escHintText = new FlxText(-310, -240, 0, "ESC: Pause/Options");
		escHintText.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 15, flixel.util.FlxColor.WHITE);
		userInterfaceGroup.add(escHintText);
		FlxTween.tween(escHintText, {alpha : 0}, 1, {
			startDelay : 10,
			onComplete : function(tween) {
				userInterfaceGroup.remove(escHintText);
			}
		});
		universalBus.pause.subscribe(this, pauseGame);
		universalBus.unpause.subscribe(this, unpauseGame);

		// Win/Lose conditions
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

		handleGameOver();
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

		handleGameOver();
	}

	private function handleGameOver() {
		var instructions = new BeatText(universalBus, "[ Press R to retry ] [ Press Space to return to Level Select ]", 20, 1.05);
		instructions.x = -instructions.width / 2;
		instructions.y = 60;
		add(instructions);

		// Music Track Credits
		var attribution = levelData.title + ", by " + levelData.composer + " (" + levelData.composerWebpage +")";
		var attributionText = new BeatText(universalBus, attribution, 15, 1.05);
		attributionText.x = -attributionText.width / 2;
		attributionText.y = 150;
		add(attributionText);

		logger.endLevel(player.hp);

		universalBus.retry.subscribe(this, function(_) {
			endPlayState(logger, levelIndex, player.hp, true);
		});

		universalBus.returnToHub.subscribe(this, function(_) {
			endPlayState(logger, levelIndex, player.hp, false);
		});

		universalBus.pause.unsubscribe(this);
		universalBus.unpause.unsubscribe(this);
	}

	public static function endPlayState(logger, levelIndex, playerHP, isRetrying) {
		FlxG.sound.music.persist = true;
		FlxG.switchState(new HubWorldState(logger, {
			level: levelIndex,
			score: playerHP
		}, isRetrying));
	}

	public function pauseGame(pauseEvent) {
		var menu = new PauseOptionsMenu(universalBus, logger, levelIndex);
		FlxTween.globalManager.active = false;
		menu.closeCallback = function() {
			universalBus.unpause.broadcast(true);
		}
		openSubState(menu);
	}

	public function unpauseGame(unpauseEvent) {
		FlxTween.globalManager.active = true;
	}

	override public function onFocus() {
		super.onFocus();
		logger.focusGained();
	}

	override public function onFocusLost() {
		super.onFocusLost();
		logger.focusLost();
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

private class ScreenBanner extends FlxSpriteGroup {
	private var texts : Array<FlxText>;
	private var speed = 200;

	public function new(universalBus : UniversalBus, text : String, size : Int) {
		super();

		var background = new FlxSprite();
        var seethroughColor = new flixel.util.FlxColor(0xcc2E4172);
        background.makeGraphic(FlxG.width, size + 10, seethroughColor);
        background.x -= background.width / 2;
        background.y -= background.height / 2 - 2;
        add(background);

		texts = [];
		texts[0] = new FlxText(0, 0, 0, text);
		texts[0].setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.WHITE);
		for (i in 1...(Math.round(FlxG.width / texts[0].width) + 1)) {
			texts[i] = new FlxText(0, 0, 0, text);
			texts[i].setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.WHITE);
		}

		for (i in 0...texts.length) {
			add(texts[i]);
			texts[i].x = i * (texts[i].width + 10) - FlxG.width / 2;
			texts[i].y -= texts[i].height / 2;
		}

		universalBus.levelStart.subscribe(this, function(_) {
			FlxTween.tween(background.scale, {
				y : 0
			}, 0.1, {
				ease : FlxEase.quadIn
			});
			for (text in texts) {
				FlxTween.tween(text, {
					alpha : 0
				}, 0.1, {
					ease : FlxEase.quadIn
				});
			}
			FlxTween.tween(this, {
				speed : 0
			}, 0.1, {
				ease : FlxEase.quadOut
			});
		});
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for (text in texts) {
			text.x -= speed * elapsed;
		}

		for (i in 0...texts.length) {
			if (texts[i].x < -texts[i].width - FlxG.width / 2) {
				var previousIdx = (i + texts.length - 1) % texts.length;
				texts[i].x = texts[previousIdx].x + (texts[i].width + 10);
			}
		}
	}
}
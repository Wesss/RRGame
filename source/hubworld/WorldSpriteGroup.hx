package hubworld;

import logging.LoggingSystem;
import level.PlayLevelState;
import flixel.FlxG;
import bus.UniversalBus;
import level.LevelDataLoader;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.*;

class WorldSpriteGroup extends FlxSpriteGroup {
    public var levels(default, null) : Array<SelectLevelButton>;

    public function new(hubWorldData : hubworld.HubWorldState.HubWorldData,
                        index : Int,
                        levelScores : Map<Int, Float>,
                        logger : LoggingSystem) {
        super(FlxG.width * index);
        var world = hubWorldData.worlds[index];
        var tutorialPassed = !world.hasTutorial || (levelScores[index * 5] != null && levelScores[index * 5] >= 1);
        // TODO : fix this                              constant       ^                                      ^

        levels = [];
        for (i in 0...world.levels.length) {
            var location = hubWorldData.buttonLocations[i];
            var button = new SelectLevelButton(
                location.x,
                location.y,
                (index + 1) + "-" + (i + 1),
                world.levels[i],
                index * 5 + i,
                //TODO: ^ and that
                levelScores[index * 5 + i],
                logger,
                !tutorialPassed && i > 0);
            add(button);
            levels.push(button);
        }
    }

    public function unlockAll() {
        FlxG.camera.shake(0.02, 0.2, function() {
            group.forEach(function(sprite) {
                cast (sprite, SelectLevelButton).unlock();
            });
        });
    }
}

class SelectLevelButton extends FlxSpriteGroup {
    private var isLocked : Bool;
    private var levelExists : Bool;
    private var button : FlxButton;
    private var lockOverlay : FlxSprite;
    private var scoreStars : ScoreStars;
    private var logger:LoggingSystem;
    private var levelIndex : Int;
    private var levelAssetPath : String;

    public function click() {
        button.onDown.fire();
    }

    public function startRetry() {
        transitionToLevel(true);
    }

    private function transitionToLevel(isRetry : Bool) {
        if (levelExists) {
            var universalBus = new UniversalBus();
            logger.startLevel(levelIndex, universalBus, isRetry);
            
            var levelData = LevelDataLoader.loadLevelData(levelAssetPath, universalBus);
            FlxG.switchState(new PlayLevelState(levelData, levelIndex, universalBus, logger));
        }
    }

    public function addScore(newScore : Float) {
        var scoreDifference = Math.round(newScore) - scoreStars.score;
        scoreStars.addScore(scoreDifference);
    }

    public function new(x : Float,
                        y : Float,
                        label : String,
                        levelAssetPath : String,
                        levelIndex : Int,
                        score : Null<Float>,
                        logger : LoggingSystem,
                        isLocked = false) {
        super(x, y);
        button = new FlxButton(0, 0, label);
        button.loadGraphic(AssetPaths.BoardSquare__png);
        button.label.setFormat(AssetPaths.GlacialIndifference_Regular__ttf,
                50, flixel.util.FlxColor.WHITE, CENTER);
        var centerOffset = new FlxPoint(0, button.height / 2 - button.label.height / 2 - 5);
        button.labelOffsets = [centerOffset, centerOffset, centerOffset];
        button.scrollFactor.x = 1;
        add(button);

        lockOverlay = new FlxSprite(0, 0, AssetPaths.LockOverlay__png);
        add(lockOverlay);

        var roundedScore = 0;
        if (score != null) {
            roundedScore = Math.round(score);
        }
        scoreStars = new ScoreStars(-1, 83, roundedScore);
        add(scoreStars);

        levelExists = openfl.Assets.list().indexOf(levelAssetPath) != -1;

        button.onDown.callback = function() {
            if (!this.isLocked) {
                transitionToLevel(false);
            }
        }

        if (!isLocked && levelExists) {
            lockOverlay.alpha = 0;
        } else {
            scoreStars.alpha = 0.01;
            scoreStars.visible = false;
        }

        this.isLocked = isLocked;
        this.levelIndex = levelIndex;
        this.levelAssetPath = levelAssetPath;
        this.logger = logger;
    }

    public function lock() {
        isLocked = true;
        lockOverlay.alpha = 1;
        scoreStars.alpha = 0.01;
        scoreStars.visible = false;
    }

    public function unlock() {
        if (!levelExists) {
            return;
        }
        FlxTween.tween({}, {}, Math.random() / 3 * 2, {
            onComplete: function(tween) {
                FlxTween.tween(lockOverlay.scale, {
                    x : 1.2,
                    y : 1.2
                }, 0.5, {
                    ease : FlxEase.quadOut
                });

                FlxTween.tween(lockOverlay, {
                    alpha : 0
                }, 0.5, {
                    ease : FlxEase.quadOut,
                    onComplete : function(tween) {
                        isLocked = false;
                    }
                });

                scoreStars.visible = true;
                FlxTween.tween(scoreStars, {
                    alpha : 1
                }, 0.5, {
                    ease : FlxEase.quadIn
                });
            }
        });
    }
}
package hubworld;

import logging.LoggingSystemTop;
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
    public function new(hubWorldData : hubworld.HubWorldState.HubWorldData,
                        index : Int,
                        levelScores : Map<Int, Float>,
                        logger : LoggingSystemTop) {
        super(FlxG.width * index);
        var world = hubWorldData.worlds[index];
        var tutorialPassed = !world.hasTutorial || levelScores[index * 5] != null || levelScores[index * 5] < 1;
        // TODO : fix this                              constant       ^                                      ^

        for (i in 0...world.levels.length) {
            var location = hubWorldData.buttonLocations[i];
            var button = new SelectLevelButton(
                location.x,
                location.y,
                (index + 1) + "-" + (i + 1),
                world.levels[i],
                index * 5 + i,
                //TODO: ^ and that
                logger,
                !tutorialPassed && i > 0);
            add(button);
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
    private var lockOverlay : FlxSprite;
    private var logger:LoggingSystemTop;

    public function new(x : Float,
                        y : Float,
                        label : String,
                        levelAssetPath : String,
                        levelIndex : Int,
                        logger : LoggingSystemTop,
                        isLocked = false) {
        super(x, y);
        var button = new FlxButton(0, 0, label);
        button.loadGraphic(AssetPaths.BoardSquare__png);
        button.label.setFormat(AssetPaths.GlacialIndifference_Regular__ttf,
                50, flixel.util.FlxColor.WHITE, CENTER);
        var centerOffset = new FlxPoint(0, button.height / 2 - button.label.height / 2 - 5);
        button.labelOffsets = [centerOffset, centerOffset, centerOffset];
        button.scrollFactor.x = 1;
        add(button);

        lockOverlay = new FlxSprite(0, 0, AssetPaths.LockOverlay__png);
        add(lockOverlay);

        button.onDown.callback = function() {
            if (!isLocked) {
                trace("Starting level: " + levelAssetPath);

                var universalBus = new UniversalBus();
                var levelData = LevelDataLoader.loadLevelData(levelAssetPath, universalBus);

                logger.startLevel(levelIndex, universalBus);
                FlxG.switchState(new PlayLevelState(levelData, levelIndex, universalBus, logger));
            }
        }

        if (!isLocked) {
            lockOverlay.alpha = 0;
        }
    }

    public function lock() {
        isLocked = true;
        lockOverlay.alpha = 1;
    }

    public function unlock() {
        FlxTween.tween(lockOverlay.scale, {
            x : 1.2,
            y : 1.2
        }, 1, {
            ease : FlxEase.quadOut
        });

        FlxTween.tween(lockOverlay, {
            alpha : 0
        }, 1, {
            ease : FlxEase.quadOut,
            onComplete : function(tween) {
                isLocked = false;
            }
        });
    }
}
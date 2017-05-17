package hubworld;

import persistent_state.SaveManager;
import flixel.text.FlxText;
import logging.*;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.tweens.*;

typedef Point = {
    var x : Int;
    var y : Int;   
}

typedef World = {
    var hasTutorial : Bool; // Forces the first level to be played before the others
    var levels : Array<String>; // Asset path of .oel level file
}

typedef HubWorldData = {
    var buttonLocations : Array<Point>;
    var worlds : Array<World>;
}

typedef NewProgress = {
    var level : Int;
    var score : Float;
}

class HubWorldState extends FlxState {
    var hubWorldData : HubWorldData;
    var cameraTarget : CameraTarget;
    var reset : Bool;
    var logger:LoggingSystem;

    // Progress related fields
    var currentScore : Null<Float>;
    var betterProgress : NewProgress; // set if the new progress is constructed with a better score than saved
    var worldProgress : Null<Int>; // set if new progress is not null and has a valid level
    var levelRelativeToWorld : Null<Int>; // the level in the world given above

    public function new(logger:LoggingSystem, ?newProgress : NewProgress, ?reset : Bool) {
        super();

        if (logger == null) {
            logger = new EmptyLogger();
        }
        this.logger = logger;
 
        hubWorldData = haxe.Json.parse(openfl.Assets.getText(AssetPaths.hubworld__json));

        if (newProgress != null) {
            logger.endLevel(newProgress.score);
            // Have the camera on the right screen that they finished the previous level
            // off of
            var levelAmountSum = 0;
            for (i in 0...hubWorldData.worlds.length) {
                levelAmountSum += hubWorldData.worlds[i].levels.length;
                if (newProgress.level < levelAmountSum) {
                    cameraTarget = new CameraTarget(i);
                    worldProgress = i;
                    levelRelativeToWorld = newProgress.level - (levelAmountSum - hubWorldData.worlds[i].levels.length);
                    break;
                }
            }
            if (cameraTarget == null) {
                // this shouldn't happen unless the level was incorrect,
                trace("Someone initialized HubWorldState with too high of a level #");
            }

            // If level cleared/improved on, show animation
            var levelScores = SaveManager.getProgress();
            currentScore = levelScores[newProgress.level];
            if (currentScore == null || newProgress.score > currentScore) {
                betterProgress = newProgress;
            } else {
                betterProgress = null;
            }
        } else {
            cameraTarget = new CameraTarget(0);
        }

        this.reset = reset;
    }

    override public function create():Void {
        super.create();
        add(cameraTarget);
        FlxG.camera.follow(cameraTarget);
        FlxG.mouse.visible = true;

        for (i in 0...hubWorldData.worlds.length) {
            var world = new WorldSpriteGroup(hubWorldData, i, SaveManager.getProgress(), logger);
            add(world);

            if (betterProgress != null && i == worldProgress) {
                if (levelRelativeToWorld == 0 && (currentScore == null || currentScore < 1) && betterProgress.score >= 1) {
                    // Tutorial passed
                    world.unlockAll();
                }

                world.levels[levelRelativeToWorld].addScore(betterProgress.score);
                var levelScores = SaveManager.getProgress();
                levelScores[betterProgress.level] = betterProgress.score;
                SaveManager.saveProgress(levelScores);
            }

            if (reset && i == worldProgress) {
                world.levels[levelRelativeToWorld].click();
            }

            if (i > 0) {
                var button = new ScreenTransitionButton(i, Left, cameraTarget.moveToScreen.bind(i - 1));
                add(button);
            }

            if (i < hubWorldData.worlds.length - 1) {
                var button = new ScreenTransitionButton(i, Right, cameraTarget.moveToScreen.bind(i + 1));
                add(button);
            }
        }

        // sound credits
        add(new ScreenTransitionButton(0, Left, cameraTarget.moveToScreen.bind(-1)));
        add(new ScreenTransitionButton(-1, Right, cameraTarget.moveToScreen.bind(0)));
        var soundCredits = new FlxText(0, 0, 0, "Sound courtesy of NoiseForFun: http://www.noiseforfun.com/\n" +
                                                "Music courtesy of the many artists on FreeMusicArchive.org,\n" +
                                                "Soundcloud, and Youtube. See the endscreen of each level for\n" +
                                                "specific track info.");
        soundCredits.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 20, flixel.util.FlxColor.WHITE, CENTER);
        soundCredits.y = FlxG.height / 2 - 40;
        soundCredits.x = -FlxG.width + 10;
        add(soundCredits);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
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

private class CameraTarget extends FlxSprite {
    private var tween : FlxTween;
    public function new(initialScreen : Int) {
        super();
        makeGraphic(1, 1);
        visible = false;

        x = screenToCenterX(initialScreen);
        y = FlxG.height / 2;
    }

    public function moveToScreen(screen : Int) {
        if (tween != null) {
            tween.cancel();
        }

        tween = FlxTween.tween(this, {
            x : screenToCenterX(screen)
        }, 0.5, {
            ease : FlxEase.quadInOut
        });
    }

    private function screenToCenterX(screen : Int) : Float {
        return screen * FlxG.width + FlxG.width / 2;
    }
}

private enum Direction {
    Left; Right;
}

private class ScreenTransitionButton extends FlxButton {
    private static var MARGIN = 10;

    public function new(screen : Int, direction : Direction, callback : Void -> Void) {
        super();
        loadGraphic(AssetPaths.RightArrowButton__png);
        switch (direction) {
            case Left  : x = FlxG.width * screen + MARGIN;
            case Right : x = FlxG.width * (screen + 1) - width - MARGIN;
        }
        y = (FlxG.height - height) / 2;
        scrollFactor.x = 1;
        flipX = direction == Left;

        onUp.callback = callback;
    }
}
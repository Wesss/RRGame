package hubworld;

import flixel.group.FlxGroup;
import persistent_state.LocalStorageManager;
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
            var levelScores = LocalStorageManager.getProgress();
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

        if (FlxG.sound.music != null) {
            FlxG.sound.music.volume = .5;
            FlxG.sound.music.persist = false;
        }

        var levelScores = LocalStorageManager.getProgress();

        for (i in 0...hubWorldData.worlds.length) {
            var world = new WorldSpriteGroup(hubWorldData, i, LocalStorageManager.getProgress(), logger);
            add(world);

            if (betterProgress != null && i == worldProgress) {
                if (levelRelativeToWorld == 0 && (currentScore == null || currentScore < 1) && betterProgress.score >= 1) {
                    // Tutorial passed
                    world.unlockAll();
                }

                world.levels[levelRelativeToWorld].addScore(betterProgress.score);
                levelScores[betterProgress.level] = betterProgress.score;
                LocalStorageManager.saveProgress(levelScores);
            }

            // if there is no level 1-1 score, start level 1-1 immediately
            if (i == 0 && !levelScores.exists(0)) {
                world.levels[0].click();
            }

            if (reset && i == worldProgress) {
                world.levels[levelRelativeToWorld].startRetry();
            }

            if (i > 0) {
                var text = "World " + i;
                var button = new ScreenTransitionButton(i, Left, text, true, cameraTarget.moveToScreen.bind(i - 1));
                add(button);
            }

            // only show button if there are more worlds to right
            if (i < hubWorldData.worlds.length - 1) {
                var numLevelsPassed = getLevelsPassedInWorld(i, levelScores);
                var isEnabled = numLevelsPassed >= 3;
                var text = "World " + (i + 2);
                var button = new ScreenTransitionButton(i, Right, text, isEnabled, cameraTarget.moveToScreen.bind(i + 1));

                // if world was just unlocked, animate it
                if (betterProgress != null &&
                        betterProgress.level >= i * 5 &&
                        betterProgress.level < i * 5 + 5 &&
                        numLevelsPassed == 3 &&
                        (currentScore == null || currentScore < 1)) {
                    button.appearForFirstTime();
                }

                add(button);
            }
        }

        // sound credits
        add(new ScreenTransitionButton(0, Left, "Credits", true, cameraTarget.moveToScreen.bind(-1)));
        add(new ScreenTransitionButton(-1, Right, "World 1", true, cameraTarget.moveToScreen.bind(0)));
        var soundCredits = new FlxText(0, 0, 0, "Sound courtesy of NoiseForFun: http://www.noiseforfun.com/\n" +
                                                "Music courtesy of the many artists on FreeMusicArchive.org,\n" +
                                                "Soundcloud, and Youtube. See the endscreen of each level for\n" +
                                                "specific track info.");
        soundCredits.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 20, flixel.util.FlxColor.WHITE, CENTER);
        soundCredits.y = FlxG.height / 2 - 40;
        soundCredits.x = -FlxG.width + 10;
        add(soundCredits);
    }

    private static function getLevelsPassedInWorld(i:Int, levelScores:Map<Int, Float>):Int {
        var numWorldLevelsPassed = 0;
        for (j in 0...5) {
            var levelScore = levelScores[i * 5 + j];
            if (levelScore != null && levelScore >= 0) {
                numWorldLevelsPassed++;
            }
        }
        return numWorldLevelsPassed;
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

private class ScreenTransitionButton extends FlxGroup {
    private static var MARGIN = 10;

    private var button:FlxButton;
    private var buttonText:FlxText;

    public function new(screen : Int, direction : Direction, text : String, isEnabled : Bool, callback : Void -> Void) {
        super();
            button = new FlxButton();
            button.loadGraphic(AssetPaths.RightArrowButton__png);
            switch (direction) {
                case Left  : button.x = FlxG.width * screen + MARGIN;
                case Right : button.x = FlxG.width * (screen + 1) - button.width - MARGIN;
            }
            button.y = (FlxG.height - button.height) / 2;
            button.scrollFactor.x = 1;
            button.flipX = direction == Left;
            if (isEnabled) {
                button.onUp.callback = callback;
            } else {
                button.alpha = 0.25;
            }

            buttonText = new FlxText();
            if (isEnabled) {
                buttonText.text = text;
            } else {
                buttonText.text = "Beat 3 levels";
            }
            buttonText.y = button.y - 18;
            buttonText.x = button.x + (button.width / 2) - (buttonText.width * 5 / 7);
        add(button);
        buttonText.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 16, flixel.util.FlxColor.WHITE, CENTER);
        add(buttonText);
    }

    public function appearForFirstTime() {
        button.alpha = 0;
        buttonText.alpha = 0;
        FlxTween.tween({}, {}, 1.3, {
            ease : FlxEase.quadOut,
            onComplete : function(tween) {
                FlxTween.tween(button, {
                    alpha : 1
                }, 0.5, {
                    ease : FlxEase.quadOut
                });
                FlxTween.tween(buttonText, {
                    alpha : 1
                }, 0.5, {
                    ease : FlxEase.quadOut
                });
            }
        });
    }
}
package hubworld;

import level.PlayLevelState;
import flixel.FlxG;
import bus.UniversalBus;
import level.LevelDataLoader;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class WorldSpriteGroup extends FlxSpriteGroup {
    var tutorialPassed : Bool; // true if tutorial is passed or if there isn't a tutorial

    public function new(hubWorldData : hubworld.HubWorldState.HubWorldData, index : Int) {
        super();
        var world = hubWorldData.worlds[index];
        tutorialPassed = !world.hasTutorial;

        for (i in 0...world.levels.length) {
            var location = hubWorldData.buttonLocations[i];
            var button = new SelectLevelButton(location.x, location.y, i + 1 + "", world.levels[i], !tutorialPassed && i > 0);
            add(button);
        }
    }
}

class SelectLevelButton extends FlxSpriteGroup {
    private var isLocked : Bool;
    private var lockOverlay : FlxSprite;

    public function new(x : Float, y : Float, label : String, levelAssetPath : String, isLocked = false) {
        super(x, y);
        var button = new FlxButton(0, 0, label);
        button.loadGraphic(AssetPaths.BoardSquare__png);
        button.label.setFormat(AssetPaths.GlacialIndifference_Regular__ttf,
                50, flixel.util.FlxColor.WHITE, CENTER);
        var centerOffset = new FlxPoint(0, button.height / 2 - button.label.height / 2 - 5);
        button.labelOffsets = [centerOffset, centerOffset, centerOffset];
        add(button);

        lockOverlay = new FlxSprite(0, 0, AssetPaths.LockOverlay__png);
        add(lockOverlay);

        button.onDown.callback = function() {
            if (!isLocked) {
                trace("Starting level: " + levelAssetPath);

                var universalBus = new UniversalBus();
                var levelData = LevelDataLoader.loadLevelData(levelAssetPath, universalBus);
                FlxG.switchState(new PlayLevelState(levelData, new FlxSpriteGroup(), universalBus));
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
        isLocked = false;
        lockOverlay.alpha = 0;
    }
}
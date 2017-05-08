package hubworld;

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
            var button = new FlxButton(location.x, location.y, "" + (i + 1));
            button.loadGraphic(AssetPaths.BoardSquare__png);
            button.label.setFormat(AssetPaths.GlacialIndifference_Regular__ttf,
                50, flixel.util.FlxColor.WHITE, CENTER);
            var centerOffset = new FlxPoint(0, button.height / 2 - button.label.height / 2 - 5);
            button.labelOffsets = [centerOffset, centerOffset, centerOffset];
            add(button);
            
            if (!tutorialPassed && i > 0) {
                var lockOverlay = new FlxSprite(location.x, location.y, AssetPaths.LockOverlay__png);
                add(lockOverlay);

                button.onDown.callback = null;
            } else {
                button.onDown.callback = function() {
                    trace("Start level: " + (i + 1));
                }
            }
        }
    }
}
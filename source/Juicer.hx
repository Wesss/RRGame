package ;

import flixel.math.FlxPoint;
import bus.UniversalBus;
import flixel.FlxG;
import flixel.text.FlxText;

class Juicer {

    public static function juiceText(text:FlxText, ?size) {
        if (size == null) {
            text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, text.size, flixel.util.FlxColor.ORANGE, CENTER);
        } else {
            text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.ORANGE, CENTER);
        }
    }

    public static function juiceLevel(universalBus:UniversalBus) {
        // Camera and camera shake
        universalBus.threatKillSquare.subscribe({}, function(displacement) {
            FlxG.camera.shake(0.01, 0.1);
        });

        universalBus.playerHPChange.subscribe({}, function(newHP) {
            FlxG.camera.flash(flixel.util.FlxColor.WHITE, 0.1);
            FlxG.camera.shake(0.01, 0.1);
        });
    }
}

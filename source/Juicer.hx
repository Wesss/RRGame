package ;

import bus.UniversalBus;
import flixel.FlxG;

class Juicer {

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

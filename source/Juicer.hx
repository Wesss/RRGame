package ;

import domain.Displacement;
import board.BoardCoordinates;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import bus.UniversalBus;
import flixel.FlxG;

class Juicer {

    public static function juiceLevel(universalBus:UniversalBus, juiceGroup:FlxSpriteGroup) {
        // Camera and camera shake
        universalBus.threatKillSquare.subscribe({}, function(displacement) {
            FlxG.camera.shake(0.01, 0.1);
        });

        universalBus.playerHPChange.subscribe({}, function(newHP) {
            FlxG.camera.flash(flixel.util.FlxColor.WHITE, 0.1);
            FlxG.camera.shake(0.01, 0.1);
        });

        // 1UP text
        universalBus.healthHit.subscribe({}, function(displacement:Displacement) {
            var text = new FlxText(BoardCoordinates.displacementToX(displacement.horizontalDisplacement),
                                    BoardCoordinates.displacementToY(displacement.verticalDisplacement),
                                    "1 UP");
            text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 22, flixel.util.FlxColor.GREEN, CENTER);
            text.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
            juiceGroup.add(text);

            FlxTween.tween(text, {
                y : BoardCoordinates.displacementToY(displacement.verticalDisplacement) - 50
            }, 3);

            text.alpha = 0;
            // quickly fade in, wait, then fade out
            FlxTween.tween(text, {
                alpha : 1
            }, .5, {
                onComplete : function(tween) {
                    FlxTween.tween({}, {}, 1.5, {
                        onComplete : function(tween) {
                            FlxTween.tween(text, {
                                alpha : 0
                            }, 1, {
                                onComplete : function(tween) {
                                    text.destroy();
                                }
                            });
                        }
                    });
                }
            });
        });
    }
}

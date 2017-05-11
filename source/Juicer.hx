package ;

import flixel.text.FlxText;

class Juicer {

    public static function juiceText(text:FlxText, ?size) {
        if (size == null) {
            text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, text.size, flixel.util.FlxColor.ORANGE, CENTER);
        } else {
            text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, size, flixel.util.FlxColor.ORANGE, CENTER);
        }
    }
}

package level;

import bus.*;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.*;

class RewindIndicator extends FlxSubState {
    private var universalBus : UniversalBus;

    public function new() {
        super();
    }

    override public function create() : Void {
        super.create();

        var background = new FlxSprite();
        var seethroughColor = new flixel.util.FlxColor(0xcc2E4172);
        background.makeGraphic(FlxG.width, cast(FlxG.height / 4), seethroughColor);
        background.x -= background.width / 2;
        background.y -= background.height / 2;
        add(background);

        var text = new FlxText(0, 0, 0, "Dodge the Red Sliders!");
		text.setFormat(AssetPaths.GlacialIndifference_Regular__ttf, 40, flixel.util.FlxColor.WHITE, CENTER);
        text.y -= text.height / 2;
        add(text);

        var startX = -text.width - FlxG.width / 2;
        var middleX = text.x - text.width / 2;
        var endX = FlxG.width / 2;

        var tweenManager = new FlxTween.FlxTweenManager();
        add(tweenManager);
        text.x = startX;
        tweenManager.tween(text, {
            x : middleX
        }, 0.8, {
            ease : FlxEase.expoOut
        }).then(tweenManager.tween(text, {
            x: endX
        }, 0.8, {
            ease : FlxEase.expoIn,
            onComplete : function(_) {
                close();
            }
        }));
    }
}
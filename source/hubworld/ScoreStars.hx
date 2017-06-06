package hubworld;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.tweens.*;

class ScoreStars extends FlxSpriteGroup {
    public static var MAX_STARS(default, null) = 4;

    private var appearSound = FlxG.sound.load(AssetPaths.NFFcoin03__ogg);

    public var score(default, null) : Int;
    private var stars : Array<FlxSprite>;

    public function new(x : Float, y : Float, initialScore : Int) {
        super(x, y, MAX_STARS);

        stars = [];

        for (i in 0...MAX_STARS) {
            stars.push(new FlxSprite());
            stars[i].loadGraphic(AssetPaths.ScoreStar__png, true, 34, 35);
            stars[i].x = i * (stars[i].width - 4);
            add(stars[i]);

            stars[i].animation.add("point", [0]);
            stars[i].animation.add("noPoint", [1]);
            if (i < initialScore) {
                stars[i].animation.play("point");
            } else {
                stars[i].animation.play("noPoint");
            }
        }

        score = initialScore;
    }

    public function addScore(scoreToAdd = 1) {
        for (i in score...score + scoreToAdd) {
            FlxTween.tween({}, {}, 0.4 * (i - score) + 0.1, {
                onComplete : function(_) {
                    appearSound.play(true);

                    stars[i].scale.x = 1.2;
                    stars[i].scale.y = 1.2;
                    stars[i].animation.play("point");
                }
            }).then(
                FlxTween.tween(stars[i].scale, {
                    x : 1.0,
                    y : 1.0
                }, 0.4, {
                    ease : FlxEase.quadIn
                })
            );
        }
        score += scoreToAdd;
    }
}
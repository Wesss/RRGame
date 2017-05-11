package;

import flixel.FlxGame;
import openfl.display.Sprite;

class TestMain extends Sprite
{
    public function new()
    {
        super();
        addChild(new FlxGame(0, 0, ControlsTest));
    }
}

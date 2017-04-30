package start_menu;

import flixel.FlxState;

/**
 * This is a FlxState that represents the first menu the player is taken to upon starting the game.
 **/
class StartMenuState extends FlxState
{
    override public function create():Void
    {
        super.create();
        var text = new flixel.text.FlxText(0, 0, 0, "TODO start menu", 18);
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}

package hubworld;

import flixel.FlxState;

class HubWorldState extends FlxState
{
    override public function create():Void
    {
        super.create();
        var text = new flixel.text.FlxText(0, 0, 0, "TODO hub world", 18);
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}

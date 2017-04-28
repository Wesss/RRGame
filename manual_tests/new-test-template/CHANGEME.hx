package;

import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class CHANGEME extends FlxState
{
    // TODO write test

	override public function create():Void
	{
		super.create();
        var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 18);
        text.screenCenter();
        add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

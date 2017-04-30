package level;

import flixel.FlxState;

class PlayLevelState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "TODO level state", 18);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

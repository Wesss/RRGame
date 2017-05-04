package;

import flixel.FlxGame;
import openfl.display.Sprite;
import start_menu.StartMenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, level.PlayLevelState));
	}
}

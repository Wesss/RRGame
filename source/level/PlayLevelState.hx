package level;

import flixel.FlxState;

class PlayLevelState extends FlxState
{
	override public function create():Void
	{

		var unibus = new bus.UniversalBus();

		add(new controls.ControlsSystemTop(unibus));
		
		var board = new Board(0, 0);
		add(board);

		var player = new Player(unibus);
		add(player);

		flixel.FlxG.camera.focusOn(new flixel.math.FlxPoint(0, 0));

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

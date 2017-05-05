package level;

import board.BoardSystemTop;
import controls.ControlsSystemTop;
import flixel.FlxState;
import flixel.FlxG;

class PlayLevelState extends FlxState
{
	override public function create():Void
	{
		var unibus = new bus.UniversalBus();

		add(new ControlsSystemTop(unibus));
		add(new BoardSystemTop(0, 0, unibus));

		FlxG.camera.focusOn(new flixel.math.FlxPoint(0, 0));
		unibus.playerMoved.subscribe(this, function(displacement) {FlxG.camera.shake(0.01, 0.1);});

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

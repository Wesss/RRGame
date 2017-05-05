package level;

import audio.AudioSystemTop;
import board.BoardSystemTop;
import controls.ControlsSystemTop;
import flixel.FlxState;
import flixel.FlxG;
import flixel.math.FlxPoint;

class PlayLevelState extends FlxState
{
	override public function create():Void
	{
		var unibus = new bus.UniversalBus();

		var audioSystem = new AudioSystemTop(unibus);
		add(new ControlsSystemTop(unibus));
		add(new BoardSystemTop(0, 0, unibus));

		FlxG.camera.focusOn(new FlxPoint(0, 0));
		unibus.playerMoved.subscribe(this, function(displacement) {FlxG.camera.shake(0.01, 0.1);});

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

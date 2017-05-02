package;

import audio.MusicTrack;
import audio.PlayMusicEvent;
import audio.AudioEvent;
import flixel.FlxG;
import flixel.text.FlxText;
import audio.AudioSystemTop;
import bus.UniversalBus;
import flixel.FlxState;

/**
 * A manual test for verifying controls are interpreted correctly
**/
class AudioTest extends FlxState {

	private var universalBus : UniversalBus;
	private var audioSystemTop : AudioSystemTop;

	override public function create():Void
	{
		super.create();
		universalBus = new UniversalBus();

		audioSystemTop = new AudioSystemTop(universalBus);

		var outputText = new FlxText(0, 0, 0, "Press A to play music", 20);
		outputText.screenCenter();
		add(outputText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A])) {
			// TODO broadcast an appropriate audio event
			universalBus.audioEvents.broadcast(new PlayMusicEvent(MusicTrack.TEST_TRACK));
		}
	}
}

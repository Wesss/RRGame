package;

import timing.BeatEvent;
import flixel.FlxG;
import flixel.text.FlxText;
import timing.TimingSystemTop;
import audio.AudioSystemTop;
import bus.UniversalBus;
import flixel.FlxState;

/**
 * A manual test for verifying that beats events aligned with the music being played
**/
class BeatAlignmentTest extends FlxState
{
	private var universalBus:UniversalBus;
	private var audioSystemTop:AudioSystemTop;
	private var timingSystemTop:TimingSystemTop;
	private var outputMsg:FlxText;

	override public function create():Void
	{
		super.create();
		universalBus = new UniversalBus();

		audioSystemTop = new AudioSystemTop(universalBus);
		timingSystemTop = new TimingSystemTop(universalBus);

		var message = "Press A to play music";
		var outputText = new FlxText(0, 0, 0, message, 20);
		outputMsg = new FlxText(50, 300, 0, "Music not started", 16);
		outputText.screenCenter();
		add(outputText);
		add(outputMsg);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		timingSystemTop.update(elapsed);

		if (FlxG.keys.anyJustPressed([A])) {
			// TODO construct appropriate level and broadcast on an appropriate bus
			audioSystemTop.loadMusicForLevel(null);
			audioSystemTop.playMusicForLevel(null);
		}
	}

	public function receiveBeatEvent(event:BeatEvent):Void {
		outputMsg.text = "" + event.beat;
	}
}

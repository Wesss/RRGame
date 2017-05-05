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

		universalBus.beat.subscribe(this, receiveBeatEvent);

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
			timingSystemTop.loadMusicInformation(135, 444);
			audioSystemTop.playMusicForLevel(null);
			timingSystemTop.trackSongStart();
		}
	}

	override public function onFocus():Void {
		super.onFocus();
		trace("Focus get!");
	}

	override public function onFocusLost():Void {
		super.onFocusLost();
		trace("Focus lost!");
	}

	public function receiveBeatEvent(event:BeatEvent):Void {
		outputMsg.text =
				"beat: " + event.beat + "\n" +
				"of 4: " + event.beat % 4;
	}
}

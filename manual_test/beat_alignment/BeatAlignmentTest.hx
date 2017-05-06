package;

import level.LevelData;
import level.LevelEvent;
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
			var levelData = new LevelData(AssetPaths.Regards_from_Mars__ogg, 135, 444, null);
			universalBus.level.broadcast(new LevelEvent(LOAD, levelData));
			universalBus.level.broadcast(new LevelEvent(START, levelData));
		}
	}

	override public function onFocus():Void {
		super.onFocus();
		trace("Focus get!");
	}

	override public function onFocusLost():Void {
		super.onFocusLost();
		trace("Focus lost!");
		timingSystemTop.pause();
	}

	public function receiveBeatEvent(event:BeatEvent):Void {
		outputMsg.text =
				"beat: " + event.beat + "\n" +
				"of 4: " + event.beat % 4;
	}
}

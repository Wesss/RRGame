package hubworld;

import level.PlayLevelState;
import flixel.FlxG;
import logging.LoggingSystemTop;
import flixel.FlxState;

class HubWorldState extends FlxState
{
    private var logger:LoggingSystemTop;

    public function new(logger:LoggingSystemTop) {
        super();
        this.logger = logger;
    }

    public function TEMP_switchToHubWorld() {
        var score:Float = null;
        // TODO PUT_THIS_CODE_IN_WHATEVER_RESTARTS_HUBWORLD
        logger.endLevel(score);
    }

    override public function create():Void
    {
        super.create();
        var text = new flixel.text.FlxText(0, 0, 0, "TODO hub world", 18);
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    public function TEMP_switchToPlayState() {
        var universalBus = null;
        var level = null;
        var levelData = null;
        var trackGroup = null;
        // TODO PUT_THIS_CODE_IN_WHATEVER_STARTS_THE_LEVEL
        logger.startLevel(level, universalBus);
        FlxG.switchState(new PlayLevelState(levelData, trackGroup, universalBus, logger));
    }
}

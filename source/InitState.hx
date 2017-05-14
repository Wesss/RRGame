package ;

import persistent_state.SaveManager;
import flixel.FlxState;
import hubworld.HubWorldState;
import flixel.FlxG;
import logging.LoggingSystemTop;

class InitState extends FlxState {

    override public function create():Void {
        super.create();

        var logger = new LoggingSystemTop();
        SaveManager.initializeSaveData();

        FlxG.switchState(new HubWorldState(logger));
    }
}

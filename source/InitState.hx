package ;

import persistent_state.SaveManager;
import flixel.FlxState;
import hubworld.HubWorldState;
import flixel.FlxG;
import logging.LoggingSystemTop;
import logging.EmptyLogger;

class InitState extends FlxState {

    override public function create():Void {
        super.create();

        #if debug
        trace("Debug mode flag on : disabling remote logging");
        var logger = new EmptyLogger();
        #else
        var logger = new LoggingSystemTop();
        #end
        SaveManager.initializeSaveData();

        FlxG.switchState(new HubWorldState(logger));
    }
}

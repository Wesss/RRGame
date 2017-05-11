package start_menu;

import logging.LoggingSystemTop;
import flixel.FlxG;
import hubworld.HubWorldState;
import flixel.FlxState;

/**
 * This is a FlxState that allows HaxeFlixel to set its state up before we transition to the hub world
 **/
class StartMenuState extends FlxState {
    private var logger:LoggingSystemTop;

    override public function create():Void {
        super.create();
        logger = new LoggingSystemTop();
        FlxG.switchState(new HubWorldState(logger));
    }

    override public function onFocus() {
        super.onFocus();
        logger.focusGained();
    }

    override public function onFocusLost() {
        super.onFocusLost();
        logger.focusLost();
    }
}

package start_menu;

import logging.LoggingSystemTop;
import flixel.FlxG;
import hubworld.HubWorldState;
import flixel.ui.FlxButton;
import flixel.FlxState;

/**
 * This is a FlxState that represents the first menu the player is taken to upon starting the game.
 **/
class StartMenuState extends FlxState
{
    private var startButton:FlxButton;
    private var logger:LoggingSystemTop;

    override public function create():Void
    {
        super.create();
        startButton = new FlxButton(0, 0, "START", startGame);
        startButton.screenCenter();
        add(startButton);
        logger = new LoggingSystemTop();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    private function startGame()
    {
        FlxG.switchState(new HubWorldState(logger));
    }
}

package pause_options_menu;

import flixel.FlxSubState;

/**
 * A menu that pauses the game and allows for manipulating persistent options settings
 **/
class PauseOptionsMenu extends FlxSubState {

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();
        // TODO draw text
    }

    override public function update(elapsed:Float) {
        // TODO poll for R and space, return to hubworld somehow from here with it
    }
}

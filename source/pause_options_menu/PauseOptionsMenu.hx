package pause_options_menu;

import flixel.FlxG;
import flixel.FlxSubState;

/**
 * A menu that pauses the game and allows for manipulating persistent options settings
 **/
class PauseOptionsMenu extends FlxSubState {

    // TODO test controls function/feel proper on unpause

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();
        // TODO draw text
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.R) {
            // TODO retry
        }

        if (FlxG.keys.justPressed.SPACE) {
            // TODO quit
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            close();
        }
    }
}

package persistent_state;

import flixel.FlxG;
import haxe.Unserializer;
import haxe.Serializer;
import js.Browser;

class SaveManager {

    private static var localStorage = Browser.window.localStorage;

    public static function initializeSaveData() {
        #if js
        if (localStorage.getItem("isInitiallized") != null) {
            return;
        }
        saveProgress(new Map<Int, Float>());
        localStorage.setItem("isInitiallized", "true");
        FlxG.sound.volume = .2;
        #else
        throw "Error: Saving is not supported on a non-js target"
        #end
    }

    public static function getProgress():Map<Int, Float> {
        #if js
        var unserializer = new Unserializer(localStorage.getItem("levelScore"));
        return unserializer.unserialize();
        #end
    }

    public static function saveProgress(progress:Map<Int, Float>):Void {
        #if js
        var serializer = new Serializer();
        serializer.serialize(progress);
        localStorage.setItem("levelScore", serializer.toString());
        #end
    }
}

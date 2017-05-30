package persistent_state;

import flixel.FlxG;
import haxe.Unserializer;
import haxe.Serializer;
import js.Browser;

class LocalStorageManager {

    private static var localStorage = Browser.window.localStorage;

    public static function initializePersistentState() {
        #if js
        if (localStorage.getItem("isInitiallized") != null) {
            return;
        }
        saveProgress(new Map<Int, Float>());
        initABTesting();
        localStorage.setItem("isInitiallized", "true");
        #else
        throw "Error: Saving is not supported on a non-js target"
        #end
    }

    public static function getProgress():Map<Int, Float> {
        var unserializer = new Unserializer(localStorage.getItem("levelScore"));
        return unserializer.unserialize();
    }

    public static function saveProgress(progress:Map<Int, Float>):Void {
        var serializer = new Serializer();
        serializer.serialize(progress);
        localStorage.setItem("levelScore", serializer.toString());
    }

    private static function initABTesting() {
        if (FlxG.random.bool()) {
            localStorage.setItem("ABTesting", "A");
        } else {
            localStorage.setItem("ABTesting", "B");
        }
    }

    public static function isBuildA():Bool {
        return localStorage.getItem("ABTesting") == "A";
    }
}

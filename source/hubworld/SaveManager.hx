package hubworld;

import haxe.Unserializer;
import haxe.Serializer;
import js.Browser;

class SaveManager {

    public static function initializeSaveData() {
        var localStorage = Browser.window.localStorage;

        if (localStorage.getItem("isInitiallized") != null) {
            return;
        }
        saveProgress(new Map<Int, Float>());
        localStorage.setItem("isInitiallized", "true");
    }

    public static function getProgress():Map<Int, Float> {
        var unserializer = new Unserializer(Browser.window.localStorage.getItem("levelScore"));
        return unserializer.unserialize();
    }

    public static function saveProgress(progress:Map<Int, Float>):Void {
        var serializer = new Serializer();
        serializer.serialize(progress);
        Browser.window.localStorage.setItem("levelScore", serializer.toString());
    }
}

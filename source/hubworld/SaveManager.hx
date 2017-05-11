package hubworld;

import haxe.Unserializer;
import haxe.Serializer;
import js.Browser;

class SaveManager {

    public static function initializeSaveData() {
        #if js
        var localStorage = Browser.window.localStorage;

        if (localStorage.getItem("isInitiallized") != null) {
            return;
        }
        saveProgress(new Map<Int, Float>());
        localStorage.setItem("isInitiallized", "true");
        #end
    }

    public static function getProgress():Map<Int, Float> {
        #if js
        var unserializer = new Unserializer(Browser.window.localStorage.getItem("levelScore"));
        return unserializer.unserialize();
        #end
    }

    public static function saveProgress(progress:Map<Int, Float>):Void {
        #if js
        var serializer = new Serializer();
        serializer.serialize(progress);
        Browser.window.localStorage.setItem("levelScore", serializer.toString());
        #end
    }
}

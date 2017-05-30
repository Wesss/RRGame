package persistent_state;

import logging.LoggingSystem;
import flixel.FlxG;
import haxe.Unserializer;
import haxe.Serializer;
import js.Browser;

class LocalStorageManager {

    private static var localStorage = Browser.window.localStorage;
    private static var abTestBuild:String = "";

    public static function initializePersistentState(logger) {
        #if js
        if (localStorage.getItem("isInitiallized") != null) {
            return;
        }
        saveProgress(new Map<Int, Float>());
        initABTesting(logger);
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

    private static function initABTesting(logger:LoggingSystem) {
        if (FlxG.random.bool()) {
            localStorage.setItem("ABTesting", "A");
        } else {
            localStorage.setItem("ABTesting", "B");
        }
        logger.logABTestBuild(LocalStorageManager.isBuildA());
    }

    public static function isBuildA():Bool {
        if (abTestBuild == "") {
            abTestBuild = localStorage.getItem("ABTesting");
        }
        return abTestBuild == "A";
    }
}

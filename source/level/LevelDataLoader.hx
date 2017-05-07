package level;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * Parses level.oel files into LevelData structures
 **/
class LevelDataLoader {

    public static function loadLevelData(levelDataAsset:Dynamic):LevelData {
        var loader = new FlxOgmoLoader(AssetPaths.testLevel__oel);

        return new LevelData(null, null, null, null);
    }
}

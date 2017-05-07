package level;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * Parses level.oel files into LevelData structures
 **/
class LevelDataLoader {

    public static function loadLevelData(levelDataAsset:Dynamic):LevelData {
        var loader = new FlxOgmoLoader(AssetPaths.testLevel__oel);

        var musicAssetPath = "assets/music/" + loader.getProperty("MusicTrack");
        var bpm = Std.parseInt(loader.getProperty("BPM"));
        var offset = Std.parseInt(loader.getProperty("MusicStartOffset"));
        return new LevelData(musicAssetPath, bpm, offset, null);
    }
}

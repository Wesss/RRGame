package level;

import domain.Displacement;
import bus.UniversalBus;
import track_action.SliderThreat;
import track_action.TrackAction;
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

        var trackActions = new Array<TrackAction>();
        var mockBus = new UniversalBus();
        // TODO DELETE THIS. Just a mock correct answer to show test passes/fails properly
//        trackActions.push(new SliderThreat(0.0, 135, new Displacement(LEFT, UP), mockBus));
//        trackActions.push(new SliderThreat(4.0, 135, new Displacement(LEFT, NONE), mockBus));
//        trackActions.push(new SliderThreat(8.0, 135, new Displacement(LEFT, DOWN), mockBus));
//        trackActions.push(new SliderThreat(12.0, 135, new Displacement(NONE, UP), mockBus));
//        trackActions.push(new SliderThreat(12.0, 135, new Displacement(NONE, NONE), mockBus));
//        trackActions.push(new SliderThreat(12.0, 135, new Displacement(NONE, DOWN), mockBus));
//        trackActions.push(new SliderThreat(16.0, 135, new Displacement(RIGHT, UP), mockBus));
//        trackActions.push(new SliderThreat(16.0, 135, new Displacement(RIGHT, NONE), mockBus));
//        trackActions.push(new SliderThreat(16.0, 135, new Displacement(RIGHT, DOWN), mockBus));
        return new LevelData(musicAssetPath, bpm, offset, trackActions);
    }
}

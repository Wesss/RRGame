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

    public static function loadLevelData(levelDataAsset:String, universalBus:UniversalBus):LevelData {
        var loader = new FlxOgmoLoader(levelDataAsset);

        var musicAssetPath = "assets/music/" + loader.getProperty("MusicTrack");
        var bpm = Std.parseInt(loader.getProperty("BPM"));
        var offset = Std.parseInt(loader.getProperty("MusicStartOffset"));
        var beatsPerPhrase = Std.parseInt(loader.getProperty("BeatsPerPhrase"));

        var trackActions = new Array<TrackAction>();

        var boardDisplayLocations = new Map<Int, Array<Grid>>();

        function parseBoardDisplays(type:String, data:Xml):Void {
            switch (type) {
                case "Board": {
                    var boardGrid:Grid = Grid.gridFromRawCoordinates(
                        Std.parseInt(data.get("x")),
                        Std.parseInt(data.get("y"))
                    );

                    trace(boardGrid);
                    boardDisplayLocations.set(Std.int(boardGrid.y / 4), new Array<Grid>());
                    boardDisplayLocations.get(Std.int(boardGrid.y / 4)).push(boardGrid);
                }
                default : throw "Unknown board display parsed";
            }
        }
        loader.loadEntities(parseBoardDisplays, "BoardDisplayLayer");
        trace(boardDisplayLocations);

        function parseEntities(type:String, data:Xml):Void {
            switch (type) {
                case "RedSlider":
                default : throw "Unknown entity parsed";
            }
        }
        loader.loadEntities(parseEntities, "Entities");

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

/**
 * Represents a position of a 16x16 grid in the OGMO tile editor.
 * For instance new Grid(1, 3) represents the grid 1 right and 3 down from the top left most grid
 **/
class Grid {

    public static inline var GRID_SIZE = 16;

    public var x(default, null):Int;
    public var y(default, null):Int;

    public function new(x, y) {
        this.x = x;
        this.y = y;
    }

    /**
     * Given an x an y in pixels, return an appropriate grid coordinate
     **/
    public static function gridFromRawCoordinates(rawX, rawY) {
        return new Grid(Std.int(rawX / GRID_SIZE), Std.int(rawY / GRID_SIZE));
    }
}

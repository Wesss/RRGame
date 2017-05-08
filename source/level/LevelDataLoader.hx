package level;

import domain.VerticalDisplacement;
import domain.HorizontalDisplacement;
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

        // map<phrase number -> phrase division count>
        var boardDisplayLocations = new Map<Int, Int>();

        // essentially a lambda for loading phrase count and divisions
        function parseBoardDisplays(type:String, data:Xml):Void {
            switch (type) {
                case "Board": {
                    var boardGrid:Grid = Grid.gridFromRawCoordinates(
                        Std.parseInt(data.get("x")),
                        Std.parseInt(data.get("y"))
                    );

                    var phraseNumber = Std.int(boardGrid.y / 4);
                    if (!boardDisplayLocations.exists(phraseNumber)) {
                        boardDisplayLocations.set(phraseNumber, 1);
                    } else {
                        boardDisplayLocations.set(phraseNumber, boardDisplayLocations.get(phraseNumber) + 1);
                    }
                }
                default : throw "Unknown board display parsed";
            }
        }
        loader.loadEntities(parseBoardDisplays, "BoardDisplayLayer");

        // essentially a lambda for loading track actions
        function parseEntities(type:String, data:Xml):Void {
            switch (type) {
                case "RedSlider": {
                    var boardGrid:Grid = Grid.gridFromRawCoordinates(
                        Std.parseInt(data.get("x")),
                        Std.parseInt(data.get("y"))
                    );

                    // vertical displacement
                    var verticalDisplacement:VerticalDisplacement = null;
                    switch (boardGrid.y % 4) {
                        case 0: verticalDisplacement = UP;
                        case 1: verticalDisplacement = NONE;
                        case 2: verticalDisplacement = DOWN;
                        default: throw "Invalid level format; beat below/above grid";
                    }
                    // horz displacement
                    var horizontalDisplacement:HorizontalDisplacement = null;
                    switch (boardGrid.x % 4) {
                        case 0: horizontalDisplacement = LEFT;
                        case 1: horizontalDisplacement = NONE;
                        case 2: horizontalDisplacement = RIGHT;
                        default: throw "Invalid level format; beat below/above grid";
                    }
                    // beatoffset
                    var phraseNumber = Std.int(boardGrid.y / 4);
                    var phraseSubdivision = Std.int(boardGrid.x / 4);
                    var phraseDivisions = boardDisplayLocations.get(phraseNumber);
                    var beatOffset:Float = (phraseNumber + (phraseSubdivision / phraseDivisions)) * beatsPerPhrase;

                    trackActions.push(
                        new SliderThreat(
                            beatOffset,
                            bpm,
                            new Displacement(horizontalDisplacement, verticalDisplacement),
                            universalBus
                        )
                    );
                }
                default : throw "Unknown entity parsed";
            }
        }
        loader.loadEntities(parseEntities, "Entities");

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

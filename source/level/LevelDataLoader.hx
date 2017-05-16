package level;

import track_action.TextTrackAction;
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
        var phraseNumberToPhraseDivisions = new Map<Int, Int>();

        // essentially a lambda for loading phrase count and divisions
        function parseBoardDisplays(type:String, data:Xml):Void {
            switch (type) {
                case "Board": {
                    var boardGrid:Grid = Grid.gridFromRawCoordinates(
                        Std.parseInt(data.get("x")),
                        Std.parseInt(data.get("y"))
                    );

                    var phraseNumber = Std.int(boardGrid.y / 4);
                    if (!phraseNumberToPhraseDivisions.exists(phraseNumber)) {
                        phraseNumberToPhraseDivisions.set(phraseNumber, 1);
                    } else {
                        phraseNumberToPhraseDivisions.set(phraseNumber, phraseNumberToPhraseDivisions.get(phraseNumber) + 1);
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
                    var boardGrid:Grid = Grid.gridFromRawXml(data);

                    var displacement = parseDisplacement(boardGrid);
                    var beatOffset = parseBeatOffset(boardGrid, beatsPerPhrase, phraseNumberToPhraseDivisions);
                    var warnTime = Std.parseInt(data.get("warningTime"));

                    trackActions.push(new SliderThreat(
                            beatOffset,
                            bpm,
                            displacement,
                            universalBus,
                            warnTime
                    ));
                }
                case "RedSliderHoming": {
                    var boardGrid:Grid = Grid.gridFromRawXml(data);

                    var beatOffset = parseBeatOffset(boardGrid, beatsPerPhrase, phraseNumberToPhraseDivisions);
                    var warnTime = Std.parseInt(data.get("warningTime"));

                    // TODO homing slider threat
//                    trackActions.push(new SliderThreatHoming(
//                        beatOffset,
//                        bpm,
//                        universalBus,
//                        warnTime
//                    ));
                    trackActions.push(new SliderThreat(
                        beatOffset,
                        bpm,
                        new Displacement(RIGHT, UP),
                        universalBus,
                        warnTime
                    ));
                }
                case "Text": {
                    var boardGrid:Grid = Grid.gridFromRawXml(data);

                    var beatOffset = parseBeatOffset(boardGrid, beatsPerPhrase, phraseNumberToPhraseDivisions);
                    var text = data.get("text");
                    var duration = Std.parseInt(data.get("beatDuration"));

                    trackActions.push(new TextTrackAction(
                            beatOffset, text, bpm, duration
                    ));
                }
                case "Comment":
                case "Empty": // TODO empty action
                default : throw "Unknown entity parsed : " + type;
            }
        }
        loader.loadEntities(parseEntities, "Entities");

        return new LevelData(musicAssetPath, bpm, offset, trackActions);
    }

    private static function parseDisplacement(boardGrid:Grid) {
        var verticalDisplacement:VerticalDisplacement = null;
        switch (boardGrid.y % 4) {
            case 0: verticalDisplacement = UP;
            case 1: verticalDisplacement = NONE;
            case 2: verticalDisplacement = DOWN;
            default: throw "Invalid level format; displacment is above or below grid";
        }

        var horizontalDisplacement:HorizontalDisplacement = null;
        switch (boardGrid.x % 4) {
            case 0: horizontalDisplacement = LEFT;
            case 1: horizontalDisplacement = NONE;
            case 2: horizontalDisplacement = RIGHT;
            default: throw "Invalid level format; displacment is left or right of grid";
        }

        return new Displacement(horizontalDisplacement, verticalDisplacement);
    }

    private static function parseBeatOffset(boardGrid:Grid,
                                            beatsPerPhrase:Int,
                                            phraseNumberToPhraseDivisions:Map<Int, Int>) {
        var phraseNumber = Std.int(boardGrid.y / 4);
        var phraseSubdivision = Std.int(boardGrid.x / 4);
        var phraseDivisions = phraseNumberToPhraseDivisions.get(phraseNumber);
        return (phraseNumber + (phraseSubdivision / phraseDivisions)) * beatsPerPhrase;
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

    /**
     * Given xml data with x and y data, return an appropriate grid coordinate
     **/
    public static function gridFromRawXml(data:Xml) {
        return Grid.gridFromRawCoordinates(
            Std.parseInt(data.get("x")),
            Std.parseInt(data.get("y"))
        );
    }
}
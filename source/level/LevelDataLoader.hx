package level;

import track_action.HealthPickupTutorial;
import track_action.RewindSliderThreat;
import track_action.Crate;
import track_action.SliderThreatHoming;
import track_action.EmptyTrackAction;
import track_action.TextTrackAction;
import track_action.TutorialCrate;
import track_action.TutorialFlag;
import domain.VerticalDisplacement;
import domain.HorizontalDisplacement;
import domain.Displacement;
import bus.UniversalBus;
import track_action.SliderThreat;
import track_action.TrackAction;
import track_action.HealthPickup;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
using StringTools;

/**
 * Parses level.oel files into LevelData structures
 **/
class LevelDataLoader {

    public static function loadLevelData(levelDataAsset:String, universalBus:UniversalBus):LevelData {
        var loader = new FlxOgmoLoader(levelDataAsset);

        var musicAssetPath = "assets/music/" + loader.getProperty("MusicTrack");

        // music track asset path should be of for assets/music/<author>/<title>.ogg
        var split = musicAssetPath.split("/");
        var title = split[3].substring(0, split[3].length - 4).split("_").join(" ");
        var composer = split[2].split("_").join(" ");
        // composer's webpage should be contained in file assets/music/<author>/<author>.att
        var composerAttributionFilePath = split.slice(0, 3).join("/") + "/" + split[2] + ".att";
        var composerWebpage = openfl.Assets.getText(composerAttributionFilePath).replace("\n", "");

        var bpm = Std.parseInt(loader.getProperty("BPM"));
        var offset = Std.parseInt(loader.getProperty("MusicStartOffset"));
        var beatsPerPhrase = Std.parseInt(loader.getProperty("BeatsPerPhrase"));

        // track actions
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
            var boardGrid:Grid = Grid.gridFromRawXml(data);
            var beatOffset = parseBeatOffset(boardGrid, beatsPerPhrase, phraseNumberToPhraseDivisions);

            switch (type) {
                case "RedSlider": {
                    var displacement = parseDisplacement(boardGrid);
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
                    var warnTime = Std.parseInt(data.get("warningTime"));

                    trackActions.push(new SliderThreatHoming(
                        beatOffset,
                        bpm,
                        universalBus,
                        warnTime
                    ));
                }
                case "Crate": {
                    var displacement = parseDisplacement(boardGrid);
                    var warnTime = Std.parseInt(data.get("warningTime"));
                    var duration = Std.parseInt(data.get("duration"));

                    trackActions.push(new Crate(
                        beatOffset,
                        bpm,
                        displacement,
                        universalBus,
                        warnTime,
                        duration
                    ));
                }
                case "HealthPickup": {
                    var displacement = parseDisplacement(boardGrid);

                    trackActions.push(new HealthPickup(
                        beatOffset,
                        displacement,
                        universalBus
                    ));
                }
                case "Comment": {

                }
                case "RedSliderRewind": {
                    var displacement = parseDisplacement(boardGrid);
                    var warnTime = Std.parseInt(data.get("warningTime"));
                    var rewindTime = Std.parseFloat(data.get("rewindTime"));

                    trackActions.push(new RewindSliderThreat(
                        beatOffset,
                        bpm,
                        displacement,
                        universalBus,
                        warnTime,
                        rewindTime
                    ));

                }
                case "HealthPickupTutorial": {
                    var displacement = parseDisplacement(boardGrid);

                    trackActions.push(new HealthPickupTutorial(
                        beatOffset,
                        displacement,
                        universalBus
                    ));
                }
                case "TutorialCrate": {
                    var displacement = parseDisplacement(boardGrid);
                    var duration = Std.parseInt(data.get("duration"));

                    trackActions.push(new TutorialCrate(
                        beatOffset,
                        displacement,
                        universalBus,
                        duration
                    ));
                }
                case "TutorialFlag": {
                    trackActions.push(new TutorialFlag(
                        beatOffset,
                        universalBus
                    ));
                }
                case "Text": {
                    var text = data.get("text");
                    var duration = Std.parseInt(data.get("beatDuration"));
                    var xPos = Std.parseInt(data.get("xPos"));
                    var yPos = Std.parseInt(data.get("yPos"));

                    trackActions.push(new TextTrackAction(
                            beatOffset, xPos, yPos, text, bpm, duration
                    ));
                }
                case "Empty": {
                    trackActions.push(new EmptyTrackAction(beatOffset));
                }
                default : throw "Unknown entity parsed : " + type;
            }
        }
        loader.loadEntities(parseEntities, "Entities");

        return new LevelData(musicAssetPath, title, composer, composerWebpage, bpm, offset, trackActions);
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
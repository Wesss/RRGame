package level;

/**
 * Represents all of the data needed to run a level of the game
 **/
class LevelData {

    public var musicTrack(default, null):FlxSoundAsset;
    public var bpm(default, null):Int;
    public var songStartOffsetMilis(default, null):Int;
    public var trackActions(default, null):List<TrackAction>;

    public function new() {
    }
}

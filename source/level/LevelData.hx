package level;

import track_action.TrackAction;
import flixel.system.FlxAssets.FlxSoundAsset;

/**
 * Represents all of the data needed to run a level of the game
 **/
class LevelData {

    public var musicTrack(default, null):FlxSoundAsset;
    public var bpm(default, null):Int;
    public var songStartOffsetMilis(default, null):Int;
    public var trackActions(default, null):Array<TrackAction>;

    public function new(musicTrackAsset, bpm, songStartoffsetMilis, trackActions) {
        this.musicTrack = musicTrackAsset;
        this.bpm = bpm;
        this.songStartOffsetMilis = songStartoffsetMilis;
        this.trackActions = trackActions;
    }
}

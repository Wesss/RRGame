package level;

import track_action.TrackAction;
import flixel.system.FlxAssets.FlxSoundAsset;

/**
 * Represents all of the data needed to run a level of the game
 **/
class LevelData {

    public var musicTrack(default, null):String;
    public var title(default, null):String;
    public var author(default, null):String;
    public var bpm(default, null):Int;
    public var songStartOffsetMilis(default, null):Int;
    public var trackActions(default, null):Array<TrackAction>;

    public function new(musicTrackAssetPath:String, bpm, songStartoffsetMilis, trackActions) {
        this.musicTrack = musicTrackAssetPath;

        // music track asset path should be of for assets/music/author/title.ogg
        var split = musicTrackAssetPath.split("/");
        this.title = split[3].substring(0, split[3].length - 4);
        this.author = split[2];

        this.bpm = bpm;
        this.songStartOffsetMilis = songStartoffsetMilis;
        this.trackActions = trackActions;
    }
}

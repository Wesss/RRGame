package level;

import track_action.TrackAction;

/**
 * Represents all of the data needed to run a level of the game
 **/
class LevelData {

    public var musicAssetPath(default, null):String;
    public var title(default, null):String;
    public var composer(default, null):String;
    public var composerWebpage(default, null):String;
    public var bpm(default, null):Int;
    public var songStartOffsetMilis(default, null):Int;
    public var trackActions(default, null):Array<TrackAction>;

    public function new(musicAssetPath:String,
                        title:String,
                        composer:String,
                        composerWebpage:String,
                        bpm:Int,
                        songStartoffsetMilis:Int,
                        trackActions) {
        this.musicAssetPath = musicAssetPath;
        this.title = title;
        this.composer = composer;
        this.composerWebpage = composerWebpage;

        this.bpm = bpm;
        this.songStartOffsetMilis = songStartoffsetMilis;
        this.trackActions = trackActions;
    }
}

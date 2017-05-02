package audio;

/**
 * An Event that plays the given music track
 **/
class PlayMusicEvent implements AudioEvent {

    public var musicTrack(default, null):MusicTrack;

    public function new(musicTrack:MusicTrack) {
        this.musicTrack = musicTrack;
    }
}

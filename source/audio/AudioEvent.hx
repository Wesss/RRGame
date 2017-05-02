package audio;

/**
 * An Event that plays music or a sound effect
 **/
class AudioEvent {

    public var musicTrack(default, null):MusicTrack;
    public var soundEffect(default, null):SoundEffect;

    public static function newMusicEvent(musicTrack):AudioEvent {
        return new AudioEvent(musicTrack, null);
    }

    public static function newSoundEvent(soundEffect):AudioEvent {
        return new AudioEvent(null, soundEffect);
    }

    private function new(musicTrack, soundEffect) {
        this.musicTrack = musicTrack;
        this.soundEffect = soundEffect;
    }

    public function isMusicTrack():Bool {
        return musicTrack != null;
    }

    public function isSoundEffect():Bool {
        return !isMusicTrack();
    }
}

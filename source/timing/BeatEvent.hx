package timing;

/**
 * Represents that a beat of a given song is now occuring.
 **/
class BeatEvent {
    // TODO make more precise than just the current beat number (ie floats between beats)
    // TODO move to domain package?

    public var beat(default, null):Int;

    public function new(beat:Int) {
        this.beat = beat;
    }
}

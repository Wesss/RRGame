package timing;

/**
 * Represents that a beat of a given song is now occuring.
 **/
class BeatEvent {

    public var beat(default, null):Float;

    public function new(beat:Float) {
        this.beat = beat;
    }
}

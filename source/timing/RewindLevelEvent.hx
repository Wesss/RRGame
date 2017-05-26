package timing;

/**
 * An event that rewinds the level the given number of beats.
 * NOTE: the exact beat rewound to may NOT be triggered. This is because most triggers occur just barely after a beat
 * (ex. rewinding back 8 beats from beat 16.025 will be rewind to about 8.025 +/- some depending on audio playhead accuracy)
 **/
class RewindLevelEvent {

    public var beatsToRewind(default, null):Float;

    public function new(beatsToRewind:Float) {
        this.beatsToRewind = beatsToRewind;
    }
}

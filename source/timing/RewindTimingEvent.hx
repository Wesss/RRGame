package timing;

class RewindTimingEvent {

    public var milisecondsToRewind(default, null):Float;
    public var milisecondsSinceLastMusicPlayheadUpdate(default, null):Float;

    public function new(milisecondsToRewind:Float, milisecondsSinceLastMusicPlayheadUpdate:Float) {
        this.milisecondsToRewind = milisecondsToRewind;
        this.milisecondsSinceLastMusicPlayheadUpdate = milisecondsSinceLastMusicPlayheadUpdate;
    }
}

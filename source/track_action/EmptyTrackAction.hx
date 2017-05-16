package track_action;

/**
 * A track action that does nothing. primarily intended to delay the end of a level
**/
class EmptyTrackAction implements TrackAction {
    public var beatOffset:Float;
    public var triggerBeats:Array<Float>;

    public function new(beatOffset : Float) {
        triggerBeats = [0];
        this.beatOffset = beatOffset;
    }

    /**
     * @param curBeat - the current beat RELATIVE to this.beatOffset
     **/
    public function updateBeat(curBeat:Float):Void {

    }

    /**
     * @param beatIndex - The index of the beat triggered within this.triggerBeats
     **/
    public function triggerBeat(beatIndex:Int):Void {

    }
}
package level;

import track_action.TrackAction;
import domain.Displacement;

class ThreatLandedEvent {

    public var position(default, null):Displacement;
    public var trackAction(default, null):TrackAction;

    public function new(position:Displacement, trackAction:TrackAction) {
        this.position = position;
        this.trackAction = trackAction;
    }
}

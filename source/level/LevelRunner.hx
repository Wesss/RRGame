package level;

import bus.Bus;
import bus.UniversalBus;
import timing.BeatEvent;
import track_action.TrackAction;

/**
 * Responsible the loading and playing of a level and returning back to the hubworld
 **/
class LevelRunner {

    private var levelEventBus:Bus<LevelEvent>;
    private var isRunningLevel = false;
    private var actions:Array<AbsoluteTrackAction>;
    private var actionsIndex:Int;
    private var lastBeat:Float;
    private var trackActions:Array<TrackAction>;
    private var universalBus:UniversalBus;

    public function new(universalBus:UniversalBus):Void {
        this.levelEventBus = universalBus.level;
        universalBus.beat.subscribe(this, beatHandler);
        universalBus.gameOver.subscribe(this, gameOverHandler);
        actions = [];
        this.universalBus = universalBus;
    }

    /**
     * starts executing the given level
     **/
    public function runLevel(levelData:LevelData) {
        if (isRunningLevel) {
            throw "Error: a level is currently running";
        }

        isRunningLevel = true;
        levelEventBus.broadcast(new LevelEvent(LOAD, levelData));
        
        // loads track actions
        for (trackAction in levelData.trackActions) {
            for (triggerBeatIdx in 0...trackAction.triggerBeats.length) {
                var triggerBeat = trackAction.triggerBeats[triggerBeatIdx];
                actions.push(new AbsoluteTrackAction(trackAction.beatOffset + triggerBeat, triggerBeatIdx, trackAction));
            }
        }

        actions.sort(function(a, b) : Int {
            if (a.absoluteBeatTime < b.absoluteBeatTime) {
                return -1;
            } else if (a.absoluteBeatTime > b.absoluteBeatTime) {
                return 1;
            }

            return 0;
        });

        actionsIndex = 0;
        lastBeat = 0;

        trackActions = levelData.trackActions;

        levelEventBus.broadcast(new LevelEvent(START, levelData));
    }

    public function beatHandler(beat : BeatEvent) {
        // Check if any trigger beats have happened
        if (actionsIndex == actions.length) {
            // game is finished
            universalBus.levelOutOfBeats.broadcast(true);
        }

        // flag to see if we trigger any beats
        // this lets us send a single event signifying beats being triggered
        var triggerBeatsTriggered = false;
        for (i in actionsIndex...actions.length) {
            if (actions[i].absoluteBeatTime >= lastBeat && actions[i].absoluteBeatTime < beat.beat) {
                actions[i].trackAction.triggerBeat(actions[i].beatIdx);
                actionsIndex++;

                triggerBeatsTriggered = true;
            } else { // Because it's sorted, we don't have to check anymore
                break;
            }
        }

        for (trackAction in trackActions) {
            trackAction.updateBeat(beat.beat);
        }

        if (triggerBeatsTriggered) {
            universalBus.triggerBeats.broadcast(beat);
        }

        lastBeat = beat.beat;
    }

    public function gameOverHandler(_) {
        universalBus.beat.unsubscribe(this);
    }
}

private class AbsoluteTrackAction {
    public var absoluteBeatTime:Float;
    public var beatIdx:Int;
    public var trackAction:TrackAction;

    public function new(absoluteBeatTime : Float, beatIdx:Int, trackAction : TrackAction) {
        this.absoluteBeatTime = absoluteBeatTime;
        this.beatIdx = beatIdx;
        this.trackAction = trackAction;
    }
}
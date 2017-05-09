package logging;

import timing.BeatEvent;
import domain.Displacement;
import bus.UniversalBus;

class LoggingSystemTop {

    // Change based on release version TODO should we load these from some data or build file?
    private static inline var CATEGORY_ID = 1;
    private static inline var VERSION = 1;
    private static inline var IS_DEV = true;

    // Constants
    private static inline var GAME_ID = 1706;
    private static inline var GAME_NAME = "rrgrid";
    private static inline var GAME_KEY = "d61513b38dcf78a8606f0b0c2bd96c06";

    // Action IDs
    private static inline var CONTROLS_ACTION_ID = 0;
    private static inline var PLAYER_HIT_ACTION_ID = 1;

    private var logger:CapstoneLogger;
    private var curBeat:Float;

    public function new() {
        logger = new CapstoneLogger(GAME_ID, GAME_NAME, GAME_KEY, CATEGORY_ID, VERSION, IS_DEV);
        var userID = logger.getSavedUserId();
        if (userID == null) {
            userID = logger.generateUuid();
        }

        // TODO pass in callback for when session is created and wait on callback before starting a level
        logger.startNewSession(userID, null);
    }

    public function startLevel(level:Int, universalBus:UniversalBus) {
        logger.logLevelStart(level);

        this.curBeat = null;
        universalBus.beat.subscribe(this, updateBeat);
        universalBus.controls.subscribe(this, logControlsInput);
        universalBus.playerHit.subscribe(this, logPlayerHit);
    }

    private function updateBeat(event:BeatEvent) {
        this.curBeat = event.beat;
    }

    private function logControlsInput(event:Displacement) {
        logger.logLevelAction(CONTROLS_ACTION_ID, {displacement : event, beat : curBeat});
    }

    private function logPlayerHit(event:Displacement) {
        logger.logLevelAction(PLAYER_HIT_ACTION_ID, {displacement : event, beat : curBeat});
    }

    public function endLevel(score:Float) {
        logger.logLevelEnd({isWin : (score > 0), score : score});
        this.curBeat = null;
    }
}

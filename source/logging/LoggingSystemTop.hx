package logging;

import level.ThreatLandedEvent;
import timing.BeatEvent;
import domain.Displacement;
import bus.UniversalBus;

class LoggingSystemTop implements LoggingSystem {

    // Change based on release version
    private static inline var CATEGORY_ID = DEBUGGING5_CATEGORY_ID;
    private static inline var VERSION = 1;

    // only to be set to false if hosting on cs.washington.edu or specific distribution sites like kongregate
    private static inline var IS_DEV = true;

    // Constants
    private static inline var GAME_ID = 1706;
    private static inline var GAME_NAME = "rrgrid";
    private static inline var GAME_KEY = "d61513b38dcf78a8606f0b0c2bd96c06";

    // action IDs
    private static inline var CONTROLS_ACTION_ID = 0;
    private static inline var PLAYER_HIT_ACTION_ID = 1;
    private static inline var PLAYER_LOSE_ACTION_ID = 2;
    // non level action IDs
    private static inline var UNFOCUS_STATE_ID = 0;
    private static inline var FOCUS_STATE_ID = 1;
    private static inline var AB_TEST_ID = 2;
    // category IDs
    private static inline var DEBUGGING_CATEGORY_ID = 1;
    private static inline var RELEASE_CATEGORY_ID = 2;
    private static inline var HOTFIX1_CATEGORY_ID = 3;
    private static inline var RELEASE2_CATEGORY_ID = 4;
    private static inline var DEBUGGING3_CATEGORY_ID = 5;
    private static inline var RELEASE3_RELEASE_ID = 6; // newgrounds
    private static inline var DEBUGGING4_CATEGORY_ID = 7;
    private static inline var RELEASE4_RELEASE_ID = 8; // game jolt, itch.io
    private static inline var DEBUGGING5_CATEGORY_ID = 9;
    private static inline var RELEASE5_CATEGORY_ID = 10; // kongregate

    private var logger:CapstoneLogger;
    private var curBeat:Float;

    public function new() {
        logger = new CapstoneLogger(GAME_ID, GAME_NAME, GAME_KEY, CATEGORY_ID, VERSION, IS_DEV);
        var userID = logger.getSavedUserId();
        if (userID == null) {
            userID = logger.generateUuid();
            logger.setSavedUserId(userID);
        }

        logger.startNewSession(userID, null);
    }

    public function startLevel(level:Int, universalBus:UniversalBus, retry:Bool) {
        logger.logLevelStart(level, {
            isRetry: retry
        });

        this.curBeat = null;
        universalBus.beat.subscribe(this, updateBeat);
        universalBus.newControlDesire.subscribe(this, logControlsInput);
        universalBus.playerHit.subscribe(this, logPlayerHit);
        universalBus.playerDie.subscribe(this, logPlayerDie);
    }

    private function updateBeat(event:BeatEvent) {
        this.curBeat = event.beat;
    }

    private function logControlsInput(event:Displacement) {
        logger.logLevelAction(CONTROLS_ACTION_ID, {displacement : event, beat : curBeat});
    }

    private function logPlayerHit(event:ThreatLandedEvent) {
        logger.logLevelAction(PLAYER_HIT_ACTION_ID, {displacement : event.position, beat : curBeat});
    }

    private function logPlayerDie(event:Displacement) {
        logger.logLevelAction(PLAYER_LOSE_ACTION_ID, {displacement : event, beat : curBeat});
    }

    public function endLevel(score:Float) {
        logger.logLevelEnd({isWin : (score > 0), score : score});
        this.curBeat = null;
    }

    public function focusLost() {
        logger.logActionWithNoLevel(UNFOCUS_STATE_ID);
    }

    public function focusGained() {
        logger.logActionWithNoLevel(FOCUS_STATE_ID);
    }

    public function logABTestBuild(isBuildA : Bool) {
        if (isBuildA) {
            logger.logActionWithNoLevel(AB_TEST_ID, {build : "A"});
        } else {
            logger.logActionWithNoLevel(AB_TEST_ID, {build : "B"});
        }
    };
}

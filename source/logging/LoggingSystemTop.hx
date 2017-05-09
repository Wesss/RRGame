package logging;

import bus.UniversalBus;

class LoggingSystemTop {

    // Change based on release version
    private static inline var categoryId = 1;
    private static inline var versionNumber = 1;
    private static inline var isDev = true;

    // Constants
    private static inline var gameID = 1706;
    private static inline var gameName = "rrgrid";
    private static inline var gameKey = "d61513b38dcf78a8606f0b0c2bd96c06";

    private var logger:CapstoneLogger;

    public function new() {
        var logger = new CapstoneLogger(gameID, gameName, gameKey, categoryId, versionNumber, isDev);
        var userID = logger.getSavedUserId();
        if (userID == null) {
            userID = logger.generateUuid();
        }

        // TODO pass in callback for when session is created and wait on callback before starting a level
        logger.startNewSession(userID, null);
    }

    public function startLevel(level:Int, universalBus:UniversalBus) {
        logger.logLevelStart(level);
    }

    public function endLevel(score:Float) {
        logger.logLevelEnd({isWin : (score > 0), score : score});
    }
}

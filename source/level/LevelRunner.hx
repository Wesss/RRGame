package level;

import bus.Bus;
import bus.UniversalBus;

/**
 * Responsible the loading and playing of a level and returning back to the hubworld
 **/
class LevelRunner {

    private var levelEventBus:Bus<LevelEvent>;
    private var isRunningLevel = false;

    public function new(universalBus:UniversalBus):Void {
        this.levelEventBus = universalBus.level;
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
        levelEventBus.broadcast(new LevelEvent(START, levelData));
    }
}

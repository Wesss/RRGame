package level;

/**
 * Represents the changing of state for a level
 **/
class LevelEvent {

    public var levelState(default, null):LevelState;
    public var levelData(default, null):LevelData;

    public function new(levelState, levelData) {
        this.levelState = levelState;
        this.levelData = levelData;
    }
}

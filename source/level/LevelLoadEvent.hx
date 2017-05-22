package level;

/**
 * Represents the changing of state for a level
 **/
class LevelLoadEvent {

    public var levelData(default, null):LevelData;

    public function new(levelData) {
        this.levelData = levelData;
    }
}

package level;

/**
 * Represents the changing of state for a level
 **/
class LevelStartEvent {

    public var levelData(default, null):LevelData;
    public var lastBeat(default, null):Float;

    public function new(levelData, lastBeat) {
        this.levelData = levelData;
        this.lastBeat = lastBeat;
    }
}

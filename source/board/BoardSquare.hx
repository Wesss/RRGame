package board;

import flixel.FlxSprite;

class BoardSquare extends FlxSprite {
    public function new(x : Float, y : Float) {
        super(x, y, AssetPaths.BoardSquare__png);
    }
}
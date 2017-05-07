package board;

import domain.*;

/**
 *  Static conversions from board coordinates to pixel coordinates
 */
class BoardCoordinates {
    public static var BOARD_SQUARE_WIDTH(default, null) : Int;
    public static var BOARD_SQUARE_HEIGHT(default, null) : Int;

    public static var MARGIN = 15;

    // This variable is used to lazily initialize the constants
    // We need Flixel to set itself up so we can compute some constants which means
    // using a static initializer won't work
    private static var INIT = false;

    public static function displacementToX(displacement : HorizontalDisplacement) : Int {
        initializeConstants();

        var xMultiplier : Int;
        switch (displacement) {
            case LEFT:  xMultiplier = -1;
            case NONE:  xMultiplier =  0;
            case RIGHT: xMultiplier =  1;
        }

        return xMultiplier * (BOARD_SQUARE_WIDTH + MARGIN);
    }

    public static function displacementToY(displacement : VerticalDisplacement) : Int {
        initializeConstants();

        var yMultiplier : Int;
        switch (displacement) {
            case UP:   yMultiplier = -1;
            case NONE: yMultiplier =  0;
            case DOWN: yMultiplier =  1;
        }

        return yMultiplier * (BOARD_SQUARE_HEIGHT + MARGIN);
    }

    private static function initializeConstants() {
        if (!INIT) {
            var square = new BoardSquare(0, 0);
            BOARD_SQUARE_WIDTH = cast (square.width, Int);
            BOARD_SQUARE_HEIGHT = cast (square.height, Int);
            INIT = true;
        }
    }
}
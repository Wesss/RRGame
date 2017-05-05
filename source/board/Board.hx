package board;

import flixel.group.FlxSpriteGroup;
import domain.*;

class Board extends FlxSpriteGroup {
    function new(xCenter : Float, yCenter : Float) {
        super(xCenter, yCenter);

        for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
                var square = new BoardSquare(BoardCoordinates.displacementToX(horizontalDisplacement) - BoardCoordinates.BOARD_SQUARE_WIDTH / 2,
                                             BoardCoordinates.displacementToY(verticalDisplacement) - BoardCoordinates.BOARD_SQUARE_HEIGHT / 2);
                add(square);
            }
        }
    }
}
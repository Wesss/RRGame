package board;

import flixel.group.FlxSpriteGroup;
import domain.*;
import bus.*;

class Board extends FlxSpriteGroup {
    function new(xCenter : Float, yCenter : Float, universalBus : UniversalBus) {
        super(xCenter, yCenter);

        for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
                var square = new BoardSquare(BoardCoordinates.displacementToX(horizontalDisplacement) - BoardCoordinates.BOARD_SQUARE_WIDTH / 2,
                                             BoardCoordinates.displacementToY(verticalDisplacement) - BoardCoordinates.BOARD_SQUARE_HEIGHT / 2,
                                             universalBus);
                add(square);
            }
        }
    }
}
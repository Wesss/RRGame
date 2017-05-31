package board;

import flixel.group.FlxSpriteGroup;
import domain.*;
import bus.*;

class Board extends FlxSpriteGroup {
    function new(xCenter : Float, yCenter : Float, universalBus : UniversalBus) {
        super(xCenter, yCenter);

        for (horizontalDisplacement in Type.allEnums(HorizontalDisplacement)) {
            for (verticalDisplacement in Type.allEnums(VerticalDisplacement)) {
                var square = new BoardSquare(new Displacement(horizontalDisplacement, verticalDisplacement), universalBus);
                add(square);
            }
        }
    }
}
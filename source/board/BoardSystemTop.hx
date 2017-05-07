package board;

import bus.UniversalBus;
import flixel.group.FlxSpriteGroup;

class BoardSystemTop extends FlxSpriteGroup {
    function new(xCenter : Float, yCenter : Float, bus : UniversalBus) {
        super(xCenter, yCenter);

        add(new Board(0, 0, bus));
        add(new Player(bus));
    }
}
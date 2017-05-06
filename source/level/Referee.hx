package level;

import bus.*;
import domain.*;

class Referee {
    private var universalBus : UniversalBus;
    private var logicalPlayerPosition : Displacement;

    public function new(universalBus : UniversalBus) {
        universalBus.playerMoved.subscribe({}, function(displacement) {
            logicalPlayerPosition = displacement;
        });

        universalBus.threatKillSquare.subscribe({}, function(displacement) {
            if (displacement.equals(logicalPlayerPosition)) {
                trace("Player hit!");
            }
        });
    }
}
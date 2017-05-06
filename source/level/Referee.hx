package level;

import bus.*;
import domain.*;

class Referee {
    private var universalBus : UniversalBus;
    private var logicalPlayerPosition : Displacement;

    public function new(universalBus : UniversalBus) {
        universalBus.playerMoved.subscribe(this, handlePlayerMove);
        universalBus.threatKillSquare.subscribe(this, handleThreatKillingSquare);
    }

    public function handlePlayerMove(displacement : Displacement) {
        logicalPlayerPosition = displacement;
    }

    public function handleThreatKillingSquare(displacement : Displacement) {
        if (displacement.equals(logicalPlayerPosition)) {
            universalBus.playerHit.broadcast(displacement);
        }
    }
}

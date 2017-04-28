package controls;
import domain.VerticalDisplacement;
import domain.HorizontalDisplacement;

/**
 * Represents all of a player's current controller input
**/
class ControlsInput {

    public var horizontalDisplacement : HorizontalDisplacement;
    public var verticalDisplacement : VerticalDisplacement;

    public function new(horizontal : HorizontalDisplacement, vertical : VerticalDisplacement) {
        this.horizontalDisplacement = horizontal;
        this.verticalDisplacement = vertical;
    }

    public function toString():String {
        return horizontalDisplacement + ", " + verticalDisplacement;
    }
}

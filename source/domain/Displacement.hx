package domain;

/**
 * Represents all of a player's current controller input
**/
class Displacement {

    public var horizontalDisplacement : HorizontalDisplacement;
    public var verticalDisplacement : VerticalDisplacement;

    public function new(horizontal : HorizontalDisplacement, vertical : VerticalDisplacement) {
        this.horizontalDisplacement = horizontal;
        this.verticalDisplacement = vertical;
    }

    public function equals(other : Displacement) {
        if (other == null) {
            return false;
        }

        return other.horizontalDisplacement == horizontalDisplacement && other.verticalDisplacement == verticalDisplacement;
    }

    public function toString():String {
        return horizontalDisplacement + ", " + verticalDisplacement;
    }
}

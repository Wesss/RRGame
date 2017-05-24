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

    public static function inCorner(d : Displacement) : Bool {
        return d.verticalDisplacement != NONE && d.horizontalDisplacement != NONE;
    }

    public static function inEdge(d : Displacement) : Bool {
        return d.verticalDisplacement == NONE && d.horizontalDisplacement != NONE ||
            d.verticalDisplacement != NONE && d.horizontalDisplacement == NONE;
    }

    public static function opposeDiagonally(d1 : Displacement, d2 : Displacement) : Bool {
        return inCorner(d1) && inCorner(d2) &&
            d1.verticalDisplacement != d2.verticalDisplacement &&
            d1.horizontalDisplacement != d2.horizontalDisplacement;
    }

    public static function opposeVertically(d1 : Displacement, d2 : Displacement) : Bool {
        return d1.horizontalDisplacement == d2.horizontalDisplacement &&
            d1.verticalDisplacement != NONE && d2.verticalDisplacement != NONE;
    }

    public static function opposeHorizontally(d1 : Displacement, d2 : Displacement) : Bool {
        return d1.verticalDisplacement == d2.verticalDisplacement &&
            d1.horizontalDisplacement != NONE && d2.horizontalDisplacement != NONE;
    }

    public static function opposeInL(d1 : Displacement, d2 : Displacement) : Bool {
        return d1.horizontalDisplacement != d2.horizontalDisplacement &&
            d1.verticalDisplacement != d2.verticalDisplacement &&
            ((inCorner(d1) && inEdge(d2)) || (inCorner(d2) && inEdge(d1)));
    }
}

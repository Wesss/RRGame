package bus;

/**
 *  Bus is an event bus to handle subscription and broadcasts of events.
 */
@:generic
class Bus<T> {
    var subscribers = new Array<(T) -> Void>();

    public function new() {
    }
    
    /**
     *  Subscribes the given function to this bus.
     *  Subscribers will be called for each message broadcasted on this bus.
     */
    public function subscribe(receiver : (T) -> Void) {
        subscribers.push(receiver);
    }

    /**
     *  Send the given event to all subscribed functions.
     */
    public function broadcast(event : T) {
        for (subscriber in subscribers) {
            subscriber(event);
        }
    }

    public function toString():String {
        return "[" + Type.getClassName(Type.getClass(this)) + " Subscribers = " + subscribers + "]";
    }
}

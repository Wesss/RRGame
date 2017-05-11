package bus;

/**
 *  Bus is an event bus to handle subscription and broadcasts of events.
 */
@:generic
class Bus<T> {
    var subscribers = new Map<{}, (T) -> Void>();

    public function new() {
    }
    
    /**
     *  Subscribes the given subscriber to this bus
     *  Subscribers will be called through the callback for each message broadcasted on this bus.
     */
    public function subscribe(subscriber, callback : (T) -> Void) {
        subscribers[subscriber] = callback;
    }

    /**
     *  Unsubscribes the given subscriber from this bus
     *  The given subscriber won't be notified of events broadcasted on this bus anymore.
     */
    public function unsubscribe(subscriber) {
        subscribers.remove(subscriber);
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

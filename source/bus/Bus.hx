package bus;

/**
 *  Bus is an event bus to handle subscription and broadcasts of events.
 */
@:generic
class Bus<T> {
    var subscribers = new Array<Receiver<T>>();

    public function new() {
    }
    
    /**
     *  Subscribes the given receiver to this bus.
     *  Subscribers will receive all messages broadcasted on this bus.
     */
    public function subscribe(receiver : Receiver<T>) {
        subscribers.push(receiver);
    }

    /**
     *  Removes the given subscriber from this bus.
     *  The given subscriber will stop receiving all messages broadcasted on this bus.
     */
    public function unsubscribe(subscriber : Receiver<T>) {
        subscribers.remove(subscriber);
    }

    /**
     *  Send the given event to all subscribers.
     *  Has the effect of calling receive(event) on every subscriber
     */
    public function broadcast(event : T) {
        for (subscriber in subscribers) {
            subscriber.receive(event);
            subscriber.
        }
    }

    public function toString():String {
        return "[" + Type.getClassName(Type.getClass(this)) + " Subscribers = " + subscribers + "]";
    }
}

@:generic
interface Receiver<T> {
    /**
     *  Receive and handle the given event
     */
    public function receive(event : T):Void;
}
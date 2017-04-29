package bus;

@:generic
class Bus<T> {
    var subscribers = new Array<Receiver<T>>();

    public function new() {
    }
    
    public function subscribe(subscriber : Receiver<T>) {
        subscribers.push(subscriber);
    }

    public function unsubscribe(subscriber : Receiver<T>) {
        subscribers.remove(subscriber);
    }

    public function broadcast(event : T) {
        for (subscriber in subscribers) {
            subscriber.receive(event);
        }
    }

    public function toString():String {
        return "[" + Type.getClassName(Type.getClass(this)) + " Subscribers = " + subscribers + "]";
    }
}

@:generic
interface Receiver<T> {
    public function receive(event : T):Void;
}
package;

import bus.Bus;
import massive.munit.Assert;

class TestBus
{
	private var bus:Bus<Int>;

	public function new() 
	{
	}

	@Before
	public function setup():Void
	{
		bus = new Bus<Int>();
	}
	
	@Test
	public function testSingleReceiver():Void
	{
		var receiver:TestReceiver<Int> = new TestReceiver<Int>();

		Assert.areEqual(null, receiver.messageReceived);

		bus.broadcast(0);

		Assert.areEqual(10, receiver.messageReceived);

		bus.subscribe(receiver);
		bus.broadcast(10);

		Assert.areEqual(10, receiver.messageReceived);

		bus.broadcast(20);

		Assert.areEqual(20, receiver.messageReceived);

		bus.unsubscribe(receiver);
		bus.broadcast(30);

		Assert.areEqual(20, receiver.messageReceived);
		trace(bus);
	}

	@Test
	public function testMultipleReceiver():Void
	{
		var receiver1 = new TestReceiver<Int>();
		var receiver2 = new TestReceiver<Int>();

		Assert.areEqual(null, receiver1.messageReceived);
		Assert.areEqual(null, receiver2.messageReceived);

		bus.subscribe(receiver1);
		bus.broadcast(10);

		Assert.areEqual(10, receiver1.messageReceived);
		Assert.areEqual(null, receiver2.messageReceived);

		bus.subscribe(receiver2);
		bus.broadcast(20);

		Assert.areEqual(20, receiver1.messageReceived);
		Assert.areEqual(20, receiver2.messageReceived);

		bus.unsubscribe(receiver1);
		bus.broadcast(30);

		Assert.areEqual(20, receiver1.messageReceived);
		Assert.areEqual(30, receiver2.messageReceived);
		trace(bus);
	}

}

@:generic
class TestReceiver<T> implements Receiver<T> {
	public var messageReceived(default, null):Null<T>;

	public function new() {
	}

	public function receive(event) {
		messageReceived = event;
	}
}
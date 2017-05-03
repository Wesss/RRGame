package;

import bus.Bus;
import massive.munit.Assert;

class TestBus
{
	private var bus:Bus<Int>;
	private var method1LastReceivedInt:Int;
	private var method2LastReceivedInt:Int;

	public function new() 
	{
	}

	@Before
	public function setup():Void
	{
		bus = new Bus<Int>();
		method1LastReceivedInt = null;
		method2LastReceivedInt = null;
	}

	private function subscribeMethod1(event:Int):Void
	{
		method1LastReceivedInt = event;
	}

	private function subscribeMethod2(event:Int):Void
	{
		method2LastReceivedInt = event;
	}
	
	@Test
	public function testSingleReceiver():Void
	{
		Assert.areEqual(null, method1LastReceivedInt);

		bus.broadcast(0);

		Assert.areEqual(null, method1LastReceivedInt);

		bus.subscribe(subscribeMethod1);
		bus.broadcast(10);

		Assert.areEqual(10, method1LastReceivedInt);

		bus.broadcast(20);

		Assert.areEqual(20, method1LastReceivedInt);
	}

	@Test
	public function testMultipleReceiver():Void
	{
		Assert.areEqual(null, method1LastReceivedInt);
		Assert.areEqual(null, method2LastReceivedInt);

		bus.subscribe(subscribeMethod1);
		bus.broadcast(10);

		Assert.areEqual(10, method1LastReceivedInt);
		Assert.areEqual(null, method2LastReceivedInt);

		bus.subscribe(subscribeMethod2);
		bus.broadcast(20);

		Assert.areEqual(20, method1LastReceivedInt);
		Assert.areEqual(20, method2LastReceivedInt);
	}
}

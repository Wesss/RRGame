package hubworld;

import flixel.FlxState;

typedef Point = {
    var x : Int;
    var y : Int;   
}

typedef World = {
    var hasTutorial : Bool; // Forces the first level to be played before the others
    var levels : Array<String>; // Asset path of .oel level file
}

typedef HubWorldData = {
    var buttonLocations : Array<Point>;
    var worlds : Array<World>;
}

class HubWorldState extends FlxState {
    var hubWorldData : HubWorldData;

    override public function create():Void {
        super.create();
        hubWorldData = haxe.Json.parse(openfl.Assets.getText(AssetPaths.hubworld__json));

        var world = new WorldSpriteGroup(hubWorldData, 0);
        add(world);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}

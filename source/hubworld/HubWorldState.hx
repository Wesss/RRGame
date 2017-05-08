package hubworld;

import flixel.FlxState;

typedef Point = {
    var x : Int;
    var y : Int;   
}

typedef Level = {
    var music : String;
    var level : String;
}

typedef World = {
    var hasTutorial : Bool; // Forces the first level to be played before the others
    var levels : Array<Level>;
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
        
        var text = new flixel.text.FlxText(0, 0, 0, "TODO hub world", 18);
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}

package;

#if MANUAL_TEST
@:build(flixel.system.FlxAssets.buildFileReferences("../../assets", true))
#else
@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
#end
class AssetPaths {}
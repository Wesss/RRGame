package;

#if MANUAL_TEST
@:build(AssetPathsMacros.buildManualTestAssets())
#else
@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
#end
class AssetPaths {}


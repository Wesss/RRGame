package;

#if MANUAL_TEST
@:build(AssetPathsMacros.buildManualTestAssets())
#elseif FLX_UNIT_TEST
@:build(flixel.system.FlxAssets.buildFileReferences("testAssets", true))
#else
@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
#end
class AssetPaths {}


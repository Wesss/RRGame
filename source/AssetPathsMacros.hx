package;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
using flixel.util.FlxArrayUtil;
using StringTools;

class AssetPathsMacros {
public static function buildManualTestAssets():Array<haxe.macro.Expr.Field>
	{			
		var fileReferences:Array<FileReference> = getFileReferences("../../assets/", true);
		
		var fields:Array<haxe.macro.Expr.Field> = Context.getBuildFields();
			
		for (fileRef in fileReferences)
		{
			// create new field based on file references!
            fileRef.value = fileRef.value.replace("../", "");
			fields.push({
				name: fileRef.name,
				doc: fileRef.documentation,
				access: [Access.APublic, Access.AStatic, Access.AInline],
				kind: FieldType.FVar(macro:String, macro $v{ fileRef.value }),
				pos: Context.currentPos()
			});
		}
		return fields;
	}
	
	private static function getFileReferences(directory:String, subDirectories:Bool = false):Array<FileReference>
	{
		var fileReferences:Array<FileReference> = [];
		var resolvedPath = #if (ios || tvos) Context.resolvePath(directory) #else directory #end;
		var directoryInfo = FileSystem.readDirectory(resolvedPath);
		for (name in directoryInfo)
		{
			if (!FileSystem.isDirectory(resolvedPath + name))
			{
				// ignore invisible files
				if (name.startsWith("."))
					continue;
				
				fileReferences.push(new FileReference(directory + name));
			}
			else if (subDirectories)
			{
				fileReferences = fileReferences.concat(getFileReferences(directory + name + "/", true));
			}
		}
		
		return fileReferences;
	}
}

private class FileReference {
	public var name:String;
	public var value:String;
	public var documentation:String;
	
	public function new(value:String) {
		this.value = value;
		
		// replace some forbidden names to underscores, since variables cannot have these symbols.
		this.name = value.split("-").join("_").split(".").join("__");
		var split:Array<String> = name.split("/");
		this.name = split.last();
		
		// auto generate documentation
		this.documentation = "\"" + value + "\" (auto generated).";
	}
}
package;
import haxe.macro.Expr;
import sys.FileSystem;
using StringTools;
/**
 * ...
 * @author 
 */
class FileList
{
	public static macro function getFileList ( folder :String, extension: String) : Expr
	{
		// the list of files to return
		var list : Array<Expr> = [];	
		// read everything that is in the directory
		var content = FileSystem.readDirectory(folder);
		for (s in content)
		{
			// if the file has the correct file extension, add it to the list
			if (s.endsWith(extension))
			{
				var path = folder + s;
				// convert the string to an expr and add it to list
				list.push(macro $v{path});
			}
		}
		// convert Array<Expr> to Expr and return
		return macro $a{list};
	}
	
}
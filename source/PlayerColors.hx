package;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PlayerColors
{
	
	private var colors : Array<FlxColor>;
	
	public function new ()
	{
		colors = new Array<FlxColor>();
		colors.push( FlxColor.fromHSB(45, 0.7, 0.8));
		colors.push( FlxColor.fromHSB(135,  0.7, 0.8));
		colors.push( FlxColor.fromHSB(215, 0.7, 0.8));
		colors.push( FlxColor.fromHSB(305, 0.7, 0.8));
	}
	
	public function get (id : Int ) : FlxColor
	{
		if (id >= 0 && id < colors.length)
		{
			return colors[id];
		}
		else 
		{
			throw "invalid id in PlayerColors: " + Std.string(id);
		}
	}
}
package;

/**
 * ...
 * @author 
 */
class MathExtender
{
	public static function Rad2Deg (v: Float) : Float
	{
		return v * 180 / Math.PI;
	}
	
	public static function Deg2Rad (v:Float) : Float
	{
		return v * Math.PI / 180;
	}
	
}
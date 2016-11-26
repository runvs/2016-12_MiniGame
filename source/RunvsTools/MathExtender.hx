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
	
	public static function ClampPM(v:Float, max : Float = 1) : Float
	{
		if (v < 0) return -max;
		if (v > 0) return max;
		else return 0;
	}
	public static function ClampPMSoft(v:Float, max : Float = 1, tol : Float = 0.5) : Float
	{
		if (v < -tol) return -max;
		if (v > tol) return max;
		else return 0;
	}
	
}
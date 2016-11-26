package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

/**
 * ...
 * @author foo
 */
class GP
{
    public static var ScreenWidth (default, null) : Int = 800;
    public static var ScreenHeight (default, null) : Int = 600;
	
	public static var PlayerAccelerationFactor (default, null) : Float = 200;
	static public var PlayerDrag (default, null) : Float = 600;
	static public var PlayerMaxVelocity (default, null) : Float = 300;
	
	static public var PCols (default, default) : PlayerColors;
	static public var PlayerShootCoolDown (default, null) : Float = 0.3;
	static public var PlayerDamageTrackIncrease ( default, null) : Float = 5;
	static public var ShotVelocity (default, null) : Float =  350;
	
	
}

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
    public static var ScreenHeight (default, null) : Int = 700;
    public static var gameTime (default, null) : Float = 120;
    // fontSize: returns 128 / 2^i 
    // -> fontSize(0) is the defined as biggest font (128)
    // -> fontSize(7) is defined as smallest font (16)
    static public function fontSize(size:Int):Int {
        // in case of invalid inputs, return the default size
        if (size < 0 || size > 8) {
            return 128;
        }
         
        var i : Int  = 128 - size * 16;
        return i;
    }

	public static var PlayerAccelerationFactor (default, null) : Float = 950;
	static public var PlayerDrag (default, null) : Float = 1000;
	static public var PlayerMaxVelocity (default, null) : Float = 300;
	
	static public var PCols (default, default) : PlayerColors;
	static public var PlayerShootCoolDown (default, null) : Float = 0.3;
	static public var PlayerDamageTrackIncrease ( default, null) : Float = 3;
	static public var ShotVelocity (default, null) : Float =  550;
	static public var PlayerSpawnProtectionTime (default, null) : Float = 2;
	
}

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

    
    // fontSize: returns 128 / 2^i 
    // -> fontSize(0) is the defined as biggest font (128)
    // -> fontSize(7) is defined as smallest font (16)
    static public function fontSize(size:Int):Int {
        // in case of invalid inputs, return the default size
        if (size < 0 || size > 8) {
            return 128;
        }
         
        var i : Int  = 128 - size * 16;
        //trace('$i');
        return i;
    }
	
	
	public static var PlayerAccelerationFactor (default, null) : Float = 200;
	static public var PlayerDrag (default, null) : Float = 600;
	static public var PlayerMaxVelocity (default, null) : Float = 300;
	
	static public var PCols (default, default) : PlayerColors;
	static public var PlayerShootCoolDown (default, null) : Float = 0.2;
	static public var PlayerDamageTrackIncrease ( default, null) : Float = 5;
	
}

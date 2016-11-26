package;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/**
 * ...
 * @author 
 */
class MyInput
{
	public static var xVal : Float = 0;
	public static var yVal : Float = 0;
	
	public static var DashButtonJustPressed      : Bool;
	public static var JumpButtonJustPressed    : Bool;
	public static var AttackButtonJustPressed   : Bool;
	public static var SpecialButtonPressed       : Bool;
	public static var InventoryButtonJustPressed : Bool;
	
	public static var GamePadConnected 			 : Bool;

	public static function reset()
	{
		xVal = yVal =0;
		DashButtonJustPressed = JumpButtonJustPressed = AttackButtonJustPressed = SpecialButtonPressed = InventoryButtonJustPressed = false;
	}
	
	public static function update ()
	{
		DashButtonJustPressed      = false;
		JumpButtonJustPressed    = false;
		AttackButtonJustPressed   = false;
		InventoryButtonJustPressed = false;
		GamePadConnected = false;
		
		xVal = 0;
		yVal = 0;
		var gp : FlxGamepad =  FlxG.gamepads.firstActive;
		if (gp != null)
		{
			GamePadConnected = true;
			xVal = gp.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			yVal = gp.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			DashButtonJustPressed = gp.justPressed.X;
			JumpButtonJustPressed = gp.justPressed.A;
			AttackButtonJustPressed = gp.justPressed.B;
			SpecialButtonPressed = gp.pressed.B;
			InventoryButtonJustPressed = gp.justPressed.Y;
		}
		
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
		{
			xVal = 1;
		}
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
		{
			xVal = -1;
		}
		
		if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
		{
			yVal = -1;
		}
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
		{
			yVal = 1;
		}
		if (FlxG.keys.justPressed.C)
		{
			DashButtonJustPressed = true;
		}
		if (FlxG.keys.justPressed.X)
		{
			JumpButtonJustPressed= true;
		}
		if (FlxG.keys.justPressed.V)
		{
			AttackButtonJustPressed = true;
		}
		if(FlxG.keys.justPressed.F)
		{
			InventoryButtonJustPressed = true;
		}
	}
}
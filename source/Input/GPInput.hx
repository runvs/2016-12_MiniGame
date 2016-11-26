package ;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/**
 * ...
 * @author 
 */
class GPInput extends BasicInput
{

	private var _gamepad : FlxGamepad = null;
	private var _id : Int = 0;
	public function new(ID : Int = 0) 
	{
		_gamepad = FlxG.gamepads.getByID(ID);
		_id = ID;
        name = "gp " +  Std.string(ID);
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		_gamepad = FlxG.gamepads.getByID(_id);
		if (_gamepad == null)
			return;
		xVal = _gamepad.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
		yVal = _gamepad.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
		
		xShootVal = _gamepad.getXAxis(FlxGamepadInputID.RIGHT_ANALOG_STICK);
		yShootVal = _gamepad.getYAxis(FlxGamepadInputID.RIGHT_ANALOG_STICK);
		
		if (Math.abs(xVal) > 0.1 || Math.abs(yVal) > 0.1)
		{
			anyPressed = true;
		}
		
		
	}
}

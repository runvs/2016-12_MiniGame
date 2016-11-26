package ;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

/**
 * ...
 * @author 
 */
class GPInput extends __ASSET__flixel_fonts_monsterrat_ttf
{

	private var _gamepad : FlxGamepad = null;
	
	public function new(ID : Int = 0) 
	{
		_gamepad = FlxG.gamepads.getByID(ID);
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (_gamepad == null)
			return;
		
		xVal = _gamepad.getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
		yVal = _gamepad.getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
	}
}
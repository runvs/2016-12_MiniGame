package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputKeyboard1 extends BasicInput
{
	
	public function new() 
	{
		
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.A)
		{
			xVal = -1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.D)
		{
			xVal = 1;
			anyPressed = true;
		}
		
		if (FlxG.keys.pressed.W)
		{
			yVal = -1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.S)
		{
			yVal = 1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.TAB)
		{
			shoot = true;
			anyPressed = true;
		}
	}
	
}
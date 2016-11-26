package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputKeyboard2 extends BasicInput
{
	
	public function new() 
	{
		
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.LEFT)
		{
			xVal = -1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			xVal = 1;
			anyPressed = true;
		}
		
		if (FlxG.keys.pressed.UP)
		{
			yVal = -1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			yVal = 1;
			anyPressed = true;
		}
		if (FlxG.keys.pressed.ENTER)
		{
			shoot = true;
			anyPressed = true;
		}
	}
	
}
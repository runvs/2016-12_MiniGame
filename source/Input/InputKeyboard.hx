package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputKeyboard extends BasicInput
{
	
	public function new() 
	{
		
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.LEFT)
		{
			trace("left");
			xVal = -1;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			xVal = 1;
		}
		
		if (FlxG.keys.pressed.UP)
		{
			yVal = -1;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			yVal = 1;
		}
	}
	
}
package;
import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author 
 */
class EndGameState extends FlxState
{

	public override function create() : Void 
	{
		super.create();
	}
	
	public override function update (elapsed : Float ) : Void 
	{
		FlxG.switchState(new StartScreen());
	}
	
}
package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite
{

	private var _state : PlayState = null;
	private var _input : BasicInput = null;
	
	
	public function new() 
	{
		super();
	}
	
	public function setState ( state : PlayState, input : BasicInput)
	{
		_state = state;
		_input = input;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		this.acceleration.x = this.acceleration.y = 0;
		
		_input.update(elapsed);
		
		this.acceleration.x = _input.xVal;
		this.acceleration.y = _input.yVal;
		
		super.update(elapsed);
		 
		trace(this.acceleration);

	}
	
	override public function draw():Void 
	{
		 super.draw();
	}
	
}
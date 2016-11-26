package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
using MathExtender;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite
{

	private var _state : PlayState = null;
	private var _input : BasicInput = null;
	public var _ID : Int = 0;
	
	public function new() 
	{
		super();
		
		
		/// graphic stuff 
		this.loadGraphic(AssetPaths.gfx_char_sheet__png, true, 50, 45, true);
		this.animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 6);
		this.animation.add("walk", [2, 3], 6);
		this.animation.add("hit", [4], 5);
		
		this.animation.play("idle");
		
		
		this.drag.set(GP.PlayerDrag, GP.PlayerDrag);
		this.maxVelocity.set(GP.PlayerMaxVelocity, GP.PlayerMaxVelocity);
		
	}
	
	public function setState ( state : PlayState, input : BasicInput, id: Int)
	{
		_state = state;
		_input = input;
		_ID = id;
		
		this.x += id * 100;
		//this.mass =  1.0 / (id + 1);
		//trace(this.mass);
		colorPlayer();
	}
	
	function colorPlayer() 
	{
		// todo
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		this.acceleration.x = this.acceleration.y = 0;
		
		_input.update(elapsed);
		
		this.angle = - 90 +  Math.atan2(_input.yVal, _input.xVal).Rad2Deg();
		
		this.acceleration.x = _input.xVal * GP.PlayerAccelerationFactor;
		this.acceleration.y = _input.yVal * GP.PlayerAccelerationFactor;
		
		if (this.velocity.x * this.velocity.x +  this.velocity.y * this.velocity.y > 250)
		{
			this.animation.play("walk");
		}
		else
		{
			this.animation.play("idle");
		}
		
		
		
		super.update(elapsed);
		 
		//trace(this.acceleration);

	}
	
	override public function draw():Void 
	{
		 super.draw();
	}
	
}
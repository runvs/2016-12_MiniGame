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
	
	public var _damageTrack : Float;
	
	private var _shootTimer : Float = 0;

	
	
	public function new() 
	{
		super();
		
		
		/// graphic stuff 
		this.loadGraphic(AssetPaths.gfx_char_sheet__png, true, 50, 45, true);
		this.animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 6);
		this.animation.add("walk", [2, 3], 6);
		this.animation.add("hit", [4], 5);
		
		this.animation.play("idle");
		
		
		// movement stuff
		this.drag.set(GP.PlayerDrag, GP.PlayerDrag);
		this.maxVelocity.set(GP.PlayerMaxVelocity, GP.PlayerMaxVelocity);
		this.elasticity = 0.0;
		
		_damageTrack = 0;
		
	}
	
	public function setState ( state : PlayState, input : BasicInput, id: Int)
	{
		_state = state;
		_input = input;
		_ID = id;
		
		this.x += id * 100;

		colorPlayer();
	}
	
	function colorPlayer() 
	{
		// todo
		
		this.pixels.lock();
		for (i in 0 ... this.pixels.width)
		{
			for (j in 0... this.pixels.height)
			{
				if (this.pixels.getPixel32(i, j) == FlxColor.fromRGB(128, 128, 128))
				{
					this.pixels.setPixel32(i, j, GP.PCols.get(_ID));
				}
			}
		}
		this.pixels.unlock();
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		
		if (_shootTimer > 0)
		{
			_shootTimer -= elapsed;
		}
		
		
		calculateElasticity();
		
		this.acceleration.x = this.acceleration.y = 0;
		
		_input.update(elapsed);
		
		this.angle = - 90 +  Math.atan2(_input.yVal, _input.xVal).Rad2Deg();
		
		this.acceleration.x = _input.xVal * GP.PlayerAccelerationFactor;
		this.acceleration.y = _input.yVal * GP.PlayerAccelerationFactor;
		
		if (Math.abs(_input.xShootVal) > 0.5 || Math.abs(_input.yShootVal) > 0.5 )
		{
			if (_shootTimer <= 0 )
			{
				shoot();
			}
		}
		
		
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
	
	function shoot() 
	{
		var s : Shot = new Shot();
		s.x = x;
		s.y = y;
		
		s.velocity.x = GP.ShotVelocity * _input.xShootVal;
		s.velocity.y = GP.ShotVelocity * _input.yShootVal;
		
		s.firedBy = _ID;
		_state.spawnShot(s);
		this._shootTimer = GP.PlayerShootCoolDown;
		
	}
	
	function calculateElasticity() 
	{
		this.elasticity = _damageTrack / 50;
	}
	
	public function hit ()
	{
		_damageTrack += GP.PlayerDamageTrackIncrease;
	}
	
	override public function draw():Void 
	{
		 super.draw();
	}
	
}
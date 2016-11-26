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
		this.animation.add("walk", [2, 3], 8);
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
		

		
		
		var xs : Float = _input.xShootVal.ClampPMSoft();
		var ys : Float = _input.yShootVal.ClampPMSoft();
	
		
		this.acceleration.x = _input.xVal * GP.PlayerAccelerationFactor;
		this.acceleration.y = _input.yVal * GP.PlayerAccelerationFactor;
		
		var axs : Bool = acceleration.x > 0;
		var ays : Bool = acceleration.y > 0;
		
		var vxs : Bool = velocity.x > 0;
		var vys : Bool = velocity.y > 0;
		
		//if (axs != vxs) velocity.x *= -0.5;
		//if (ays != vys) velocity.y *= -0.5;
		if (axs != vxs) acceleration.x *= 4;
		if (ays != vys) acceleration.y *= 4;
		
		var velAbs : Float = Math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
		if ( velAbs > GP.PlayerMaxVelocity)
		{
			velocity.x /= velAbs / GP.PlayerMaxVelocity;
			velocity.y /= velAbs / GP.PlayerMaxVelocity;
		}
		
		
		var RTabs = Math.sqrt(xs * xs + ys * ys);
		if (RTabs > 0.4)
		{
			this.angle = - 90 +  Math.atan2(ys, xs).Rad2Deg();
			if (_shootTimer <= 0 )
			{
				shoot();
			}
		}
		else
		{
			this.angle = -90 + Math.atan2(velocity.y, velocity.x).Rad2Deg();
		}
		//if (Math.abs(_input.xShootVal) > 0.5 || Math.abs(_input.yShootVal) > 0.5 )
		super.update(elapsed);
		
		
		if (this.velocity.x * this.velocity.x +  this.velocity.y * this.velocity.y > 250)
		{
			this.animation.play("walk");
		}
		else
		{
			this.animation.play("idle");
		}
		

		 
		//trace(this.acceleration);

	}
	
	function shoot() 
	{
		var s : Shot = new Shot();
		s.x = x;
		s.y = y;
		
		var xs : Float = _input.xShootVal.ClampPMSoft();
		var ys : Float = _input.yShootVal.ClampPMSoft();
		s.angle = Math.atan2(ys, xs).Rad2Deg();
		
		var l : Float = Math.sqrt(xs * xs + ys * ys);
		
		
		s.velocity.x = GP.ShotVelocity * xs/l;
		s.velocity.y = GP.ShotVelocity * ys/l;
		
		
		
		
		s.colorMe(_ID);
		
		
		_state.spawnShot(s);
		this._shootTimer = GP.PlayerShootCoolDown;
		
	}
	
	function calculateElasticity() 
	{
		this.elasticity = _damageTrack / 50;
	}
	
	public function getDamageTrack()
	{
		return this._damageTrack;
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
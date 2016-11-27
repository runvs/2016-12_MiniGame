package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
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

	private var hitColorTween : FlxTween = null;
	
	private var accsummedX : Float = 0;
	private var accsummedY : Float = 0;
	
	public var _collideCooldown  : Float = 0;
	
	public var deaths : Int = 0;
	
	public var _acceptinput : Bool = true;
	
	private var shootSound : FlxSound;
	private var hitSound : FlxSound;
	private var deathSound : FlxSound;

	public var _lastangle : Float = 0;

	public var _ammunition : Int = 15;
	
	public var _timeTilSpawn : Float = 0;
	
	public function new() 
	{
		super(FlxG.width/2, FlxG.height/2);
		
		
		/// graphic stuff 
		this.loadGraphic(AssetPaths.gfx_char_sheet__png, true, 50, 45, true);
		this.animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 6);
		this.animation.add("walk", [2, 3], 8);
		this.animation.add("hit", [4], 5);
		
		this.animation.play("idle");
		
		
		// movement stuff
		this.drag.set(GP.PlayerDrag, GP.PlayerDrag);
		this.maxVelocity.set(GP.PlayerMaxVelocity, GP.PlayerMaxVelocity);
		this.elasticity = 1.0;
		
		_damageTrack = 0;
		
		
		shootSound = FlxG.sound.load(AssetPaths.shoot__wav);
		hitSound = FlxG.sound.load(AssetPaths.hit__wav);
		deathSound = FlxG.sound.load(AssetPaths.death__wav);
	}
	
	public function setState ( state : PlayState, input : BasicInput, id: Int)
	{
		_state = state;
		_input = input;
		_ID = id;
		this.x += id * 100;
		colorPlayer();
		respawn(true);
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
		if (this.color == FlxColor.GRAY)
		{
			if (_timeTilSpawn >= GP.PlayerSpawnProtectionTime)
			{
				color = FlxColor.WHITE;
			}
		}
		
		_collideCooldown -= elapsed;
		if (_shootTimer > 0)
		{
			_shootTimer -= elapsed;
		}
		
		_timeTilSpawn += elapsed;
		
		calculateElasticity();
		
		if (_acceptinput)
		{
			handleInputAndMovement(elapsed);
		}
		else
		{
			velocity.set();
			acceleration.set();
		}
		
		if (_acceptinput)
		{
			if (this.velocity.x * this.velocity.x +  this.velocity.y * this.velocity.y > 250)
			{
				this.animation.play("walk");
			}
			else
			{
				this.animation.play("idle");
			}
		}

	}
	

	
	function shoot() 
	{
		if (_ammunition > 0)
		{
			_ammunition -= 1;
			var s : Shot = new Shot();
			
			
			s.x = x ;
			
			s.y = y;
			
			var xs : Float = _input.xShootVal.ClampPMSoft();
			var ys : Float = _input.yShootVal.ClampPMSoft();
			s.angle = Math.atan2(ys, xs).Rad2Deg();
			
			var l : Float = Math.sqrt(xs * xs + ys * ys);
			
			
			s.velocity.x = GP.ShotVelocity * xs/l + velocity.x/2;
			s.velocity.y = GP.ShotVelocity * ys/l + velocity.y/2; 
			
			s.colorMe(_ID);

			_state.spawnShot(s);
			this._shootTimer = GP.PlayerShootCoolDown * (1 - _damageTrack / 150);
			if (this._shootTimer <= 0.1) _shootTimer = 0.1;
			shootSound.play();
		}
		
	}
	
	function calculateElasticity() 
	{
		this.elasticity = 1.0 +  _damageTrack / 35;
	}
	
	function handleInputAndMovement(elapsed : Float):Void 
	{
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
			if (velocity.y == 0 && velocity.x == 0)
			{
				this.angle = _lastangle;
			}
			else
			{
				this.angle = -90 + Math.atan2(velocity.y, velocity.x).Rad2Deg();
			}
		}
		_lastangle = angle;
	
		if (accsummedX > 3000) accsummedX = 3000;
		if (accsummedX < -3000) accsummedX = -3000;
		if (accsummedY > 3000) accsummedY = 3000;
		if (accsummedY < -3000) accsummedY = -3000;
		velocity.x += accsummedX;
		velocity.y += accsummedY;
		
		super.update(elapsed);
		
		accsummedX = accsummedY = 0;
	}
	
	
	
	public function getDamageTrack()
	{
		var s : Shot = new Shot();
        // dimensions of the shot : x = 64; y = 16
        s.offset.y = s.height/2;
        s.offset.x = s.width/2;
        
        trace(this.angle);
		s.x = x + (this.width/2) + (this.width/2) * 0;
		s.y = y + (this.height/2) - (this.height/2)  * 0;
		
		var xs : Float = _input.xShootVal.ClampPMSoft();
		var ys : Float = _input.yShootVal.ClampPMSoft();
		s.angle = Math.atan2(ys, xs).Rad2Deg();
		
		var l : Float = Math.sqrt(xs * xs + ys * ys);
		
		s.velocity.x = GP.ShotVelocity * xs/l;
		s.velocity.y = GP.ShotVelocity * ys/l;

		s.colorMe(_ID);
		
		
		_state.spawnShot(s);
		this._shootTimer = GP.PlayerShootCoolDown;
		
		return this._damageTrack;
	}
	
	
	public function die ()
	{
		deathSound.play();
		_acceptinput = false;
		
		this.animation.play("hit", true);
		
		FlxTween.tween(this, { alpha: 0 }, 0.75);
		FlxTween.tween(this.scale, { x: 0, y: 0 }, 0.75, { onComplete:
		function(t)
		{
			respawn();
		}
		});
	}
	
	public function respawn (first: Bool= false)
	{
		_ammunition = 15;
		this.scale.set(1, 1);
		this.alpha = 1;
		_timeTilSpawn = 0;
		if (first)
		{
			this.setPosition(FlxG.width / 2 + 50 * Math.cos(_ID / 4 * Math.PI) , FlxG.height / 2 + 50 * Math.sin(_ID / 4 * Math.PI));
			_timeTilSpawn = GP.PlayerSpawnProtectionTime;
		}
		else
		{
			this.setPosition(FlxG.width / 2 , FlxG.height / 2);
			this.color = FlxColor.GRAY;			
		}
		_damageTrack = 0;
		deaths += 1;
		_acceptinput = true;
	}

	
	
	public function hit (s: Shot)
	{
		hitSound.play();
		_collideCooldown = 0.25;
		
		if (hitColorTween == null || hitColorTween.finished)
		{
			hitColorTween = FlxTween.color(this, 0.25, FlxColor.RED, FlxColor.WHITE);
		}
		else 
		{
			hitColorTween.cancel();
			hitColorTween = FlxTween.color(this, 0.25, FlxColor.RED, FlxColor.WHITE);
		}
	
		if (s != null)
		{
			//trace(s.velocity);
			accsummedX = s.velocity.x * elasticity * 4;
			accsummedY = s.velocity.y * elasticity * 4;
		}
		_damageTrack += GP.PlayerDamageTrackIncrease;
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
}

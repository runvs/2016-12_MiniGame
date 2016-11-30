package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
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
	
	private  var _shootTimer : Float = 0;

	private var hitColorTween : FlxTween = null;
	
	private var accsummedX : Float = 0;
	private var accsummedY : Float = 0;
	
	public var _collideCooldown  : Float = 0;
	
	public var _acceptinput : Bool = true;
	
	private var shootSound : FlxSound;
	private var hitSound : FlxSound;
	private var deathSound : FlxSound;
	private var pickupSound : FlxSound;

	public var _lastangle : Float = 0;

	public var _ammunition : Int = 15;
	
	public var _timeTilSpawn : Float = 0;
	
	public var deaths : Int = 0;
	public var _shotsFired : Int = 0;
	public var averageDamage : Float;
	private var _summedDamage : Float = 0;
	private var _counts : Int = 0;
	
	public var _highestDamage :Float = 0;
	
	public var _numberOfPickUps : Int = 0;
	
	public var _glowoverlay : FlxSprite;
	
	public var _hitTimer : Float = 0;
	private var _lastHitVelocity : FlxPoint;
	
	public function new() 
	{
		super(FlxG.width/2, FlxG.height/2);
		_lastHitVelocity = new FlxPoint();
		
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
		pickupSound = FlxG.sound.load(AssetPaths.snd_dong__wav);
		
		var t : FlxTimer = new FlxTimer();
		t.start(1, 
		function (t) 
		{
			_counts += 1; 
			
			_summedDamage += _damageTrack; 
			averageDamage = _summedDamage / _counts; 
			
			if (_damageTrack >= _highestDamage) _highestDamage = _damageTrack;
		}, 0
		);
		
		_glowoverlay = new GlowOverlay(0, 0, FlxG.camera, Std.int(Math.max(this.width * 2, this.height * 2)), 1, 1);
		_glowoverlay.color = FlxColor.fromRGB(255, 180, 80);
		_glowoverlay.blend = BlendMode.ADD;
		
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
		
	
		
		if (_acceptinput)
		{
			handleInputAndMovement(elapsed);
			
			handleAnimations();
			
			if (_hitTimer  > 0)
			{
				_hitTimer -= elapsed;
				if (_hitTimer >= 0.4)
				{
					_hitTimer = 0.4;
				}
			}
			else
			{
				_hitTimer = 0;
			}
			calculateElasticity();
		}
		else
		{
			velocity.set();
			acceleration.set();
		}
		super.update(elapsed);
		
		accsummedX = accsummedY = 0;
	}
	

	
	function shoot() 
	{
		if (_ammunition > 0)
		{
			_ammunition -= 1;
			var s : Shot = new Shot();
			
			_shotsFired += 1;
			
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
			
			shootSound.pitch = FlxG.random.float(0.85, 1.15);
			shootSound.play();
		}
		
	}
	
	function calculateElasticity() 
	{
		//this.elasticity = 1.0 +  _damageTrack / 35 + _damageTrack / 2 * _hitTimer;
		this.elasticity = 1.0 +  _damageTrack / 35;// + _damageTrack / 2 * _hitTimer;
		
		var dV : Float = GP.PlayerDrag * ( 1.0 - 2* _hitTimer);
		this.drag.set(dV, dV);
		
		var f : Float = 5000;
		this.acceleration.x += _lastHitVelocity.x * _hitTimer  * f;
		this.acceleration.y += _lastHitVelocity.y * _hitTimer  * f;
		this.velocity.x += _lastHitVelocity.x * _hitTimer * _hitTimer * f;
		this.velocity.y += _lastHitVelocity.y * _hitTimer * _hitTimer * f;
		
		var mvV : Float = GP.PlayerMaxVelocity * ( 1 + 1000 * _hitTimer);
		if (_hitTimer > 0)
		{
			trace(_lastHitVelocity.x * _hitTimer * _hitTimer * f);
		}
		//this.maxVelocity.set(mvV, mvV);
	}
	
	function handleInputAndMovement(elapsed : Float):Void 
	{
		this.acceleration.x = this.acceleration.y = 0;
		
		_input.update(elapsed);
		var xs : Float = _input.xShootVal.ClampPMSoft();
		var ys : Float = _input.yShootVal.ClampPMSoft();
	
		
		this.acceleration.x = (_input.xVal * GP.PlayerAccelerationFactor) * (1 - _hitTimer);
		this.acceleration.y = (_input.yVal * GP.PlayerAccelerationFactor) * (1 - _hitTimer);
		
		var axs : Bool = acceleration.x > 0;
		var ays : Bool = acceleration.y > 0;
		
		var vxs : Bool = velocity.x > 0;
		var vys : Bool = velocity.y > 0;
		
		if (_hitTimer <= 0)
		{
			if (axs != vxs) acceleration.x *= 4;
			if (ays != vys) acceleration.y *= 4;
		}
		
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
	}
	
	function handleAnimations():Void 
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
	
	public function heal()
	{
		_damageTrack *= 0.5;
	}
		
	public function addAmmu()
	{
		_ammunition += 15;
		_numberOfPickUps += 1;
		pickupSound.play();
	}
	
	public function die ()
	{
		deathSound.play();
		if (hitColorTween != null) hitColorTween.cancel();
		_acceptinput = false;
		
		this.animation.play("hit", true);
		
		FlxTween.tween(this._glowoverlay, { alpha : 0 }, 0.75);
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
		this._glowoverlay.alpha = 1;
		_timeTilSpawn = 0;
		if (first)
		{
			this.setPosition(FlxG.width / 2 + 90 * Math.cos(_ID / 2 * Math.PI) , FlxG.height / 2 + 90 * Math.sin(_ID / 2 * Math.PI));
			_timeTilSpawn = GP.PlayerSpawnProtectionTime;
		}
		else
		{
			this.setPosition(FlxG.width / 2 - this.width/2 , FlxG.height / 2 - this.width/2);
			this.color = FlxColor.GRAY;			
		    deaths += 1;
		}
		_damageTrack = 0;
		_acceptinput = true;
	}

	
	
	public function hit (dir:FlxPoint)
	{
		hitSound.pitch = FlxG.random.float(0.85, 1.15);
		hitSound.play();
		_collideCooldown = 0.25;
		
		_hitTimer = _damageTrack / 400.0;
		
		FlxG.camera.shake(0.005, 0.1);
		
		if (hitColorTween == null || hitColorTween.finished)
		{
			hitColorTween = FlxTween.color(this, 0.25, FlxColor.RED, FlxColor.WHITE);
		}
		else 
		{
			hitColorTween.cancel();
			hitColorTween = FlxTween.color(this, 0.25, FlxColor.RED, FlxColor.WHITE);
		}

		//trace(s.velocity);
		var l : Float = Math.sqrt(dir.x * dir.x  + dir.y * dir.y);
		accsummedX = dir.x/l * elasticity * 4;
		accsummedY = dir.y/l * elasticity * 4;
		_lastHitVelocity.set(dir.x/l, dir.y/l);

		_damageTrack += GP.PlayerDamageTrackIncrease;
	}
	
	override public function draw():Void 
	{
		_glowoverlay.x = x + width/2;
		_glowoverlay.y = y + height/2;
		_glowoverlay.draw();
		super.draw();
		
	}
	
}

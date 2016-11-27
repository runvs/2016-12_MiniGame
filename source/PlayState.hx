package;

import flash.utils.Timer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{

	private var _players : FlxTypedGroup<Player>;
	private var _level : Level;
	private var _gi : GameInterface;
	
	private var _startPlayers : Array<String>;
	
	private var _effects : FlxSpriteGroup;
	
	private var _timer : Float = 120;
	private var _timerText : FlxText;
	private var _timerPunchTimer : FlxTimer;
	
	private var _inputEnabled : Bool = true;
	
	private var _ammunitionSpawnTimer : Float = 5;
	
	
	public function new ()
	{
		super();
		_startPlayers = new Array<String>();
	}
	
	public function addPlayer(name : String)
	{
		_startPlayers.push(name);

	}
	
	public function setTimer (t : Float )
	{
		_timer = t;
		FlxTween.color(_timerText, 10, FlxColor.WHITE, FlxColor.RED, { startDelay: _timer - 10 } );
	}
	
	override public function create():Void
	{
		super.create();
		
		
		
		_effects = new FlxSpriteGroup();
		
		_players = new FlxTypedGroup<Player> ();
		var _playersArray = new Array<Player> ();

		for (i in 0 ... _startPlayers.length)
		{
			var p : Player = new Player();
			p.setState(this, String2BasicInput.get(_startPlayers[i]), i);
			_players.add(p);
			_playersArray.push(p);
		}
		
		_gi = new GameInterface(_playersArray);
		_level = new Level();
		
        _timerText = new FlxText(0, 0, FlxG.width, "", 28);
        _timerText.font = "assets/data/MECHAG.ttf";
		_timerText.alignment = FlxTextAlign.CENTER;
		_timerText.screenCenter(FlxAxes.X);
		_timerText.y = 16;
		
		_timerPunchTimer = new FlxTimer();
		_timerPunchTimer.start(5, 
		function (t) 
		{
			_timerText.scale.set(1.5, 1.5); 
			var tw : FlxTween = FlxTween.tween(_timerText.scale, { x:1, y:1 }, 1); 
			//var cl : FlxTween.color(_timerText, 0.5, FlxColor.GRAY, FlxColor.WHITE);
		} 
		, 0);
		
		
		
		
	}

	override public function update(elapsed:Float):Void
	{
		cleanEffects();
		_level.cleanShots();
		_level.cleanAmmu();
		if (_timer > 0)
		{
			_timer -= elapsed;
		}
		
		if (_timer <= 0)
		{
			endGame();
		}
		
		super.update(elapsed);
		FlxG.collide(_players, _players, playerhit);
		
		for (p in _players)
		{
			if (p._acceptinput)
			{
				
				var dx = FlxG.width / 2 - (p.x + p.width/2) ;
				var dy = FlxG.height/ 2 - (p.y + p.height/2) ;
				var r : Float = dx*dx + dy*dy;
				//trace(_level._radius);
				if (r > _level._radius * _level._radius)
				{
					p.die();
				}
			}
		}
		
		
		
		if (_inputEnabled)
		{
			for (p in _players)
			{
				p.update(elapsed);
			}
			_level._shots.update(elapsed);
			
			if (_ammunitionSpawnTimer  > 0)
			{
				_ammunitionSpawnTimer -= elapsed;
				
			}
			trace(_ammunitionSpawnTimer);
			if (_ammunitionSpawnTimer <= 0)
			{
				_ammunitionSpawnTimer = FlxG.random.float(5, 10);
				SpawnAmmu();
			}
			
		}
		
		
		for (p in _players)
		{
			for (crate in _level._amminutionpacks)
			{
				if (FlxG.overlap(p, crate))
				{
					p.addAmmu();
					crate.alive = false;
				}
			}
			if (p._timeTilSpawn <= GP.PlayerSpawnProtectionTime) continue;
			for (s in _level._shots)
			{
				
				if (s.alive == false) continue;
				if (s.firedBy == p._ID) continue;
				
				if ( FlxG.overlap(p, s))
				{
					p.hit(s);
					FlxObject.separate(p, s);
					s.alive = false;
					spawnHit(s);
				}
			}
		}
		_gi.update(elapsed);
		_effects.update(elapsed);
		_timerText.update(elapsed);
		
		var dec: Int = Std.int((_timer * 10) % 10);
		if (dec < 0) dec *= -1;
		_timerText.text = Std.string(Std.int(_timer) + "." + Std.string(dec));
	}
	
	function SpawnAmmu() 
	{
		trace("spawn");
		var a : Float = FlxG.random.float(0, Math.PI);
		var r : Float = FlxG.random.float(0, 1) + FlxG.random.float(0, 1);
		while (r > 1) r = FlxG.random.float(0, 1) + FlxG.random.float(0, 1);
		var crate : FlxSprite = new FlxSprite(FlxG.width / 2 + r * Math.cos(a), FlxG.height / 2 + r * Math.sin(a));
		
		_level._amminutionpacks.add(crate);
	}
	
	function playerhit(p1 : Player, p2 : Player) 
	{
		if (p1._acceptinput && p1._collideCooldown <= 0 && (p1._timeTilSpawn > GP.PlayerSpawnProtectionTime)) p1.hit(null);
		if (p2._acceptinput && p2._collideCooldown <= 0 && (p2._timeTilSpawn > GP.PlayerSpawnProtectionTime)) p2.hit(null);
	}
	
	
	function endGame() 
	{
		
		_inputEnabled = false;
		FlxG.camera.fade(FlxColor.BLACK, 1.0, false, function(){DoEndGame();});
	}
	
		function DoEndGame():Void 
	{
		var e : EndGameState = new EndGameState();
		FlxG.switchState(e);
	}
	
	override public function draw () : Void 
	{
		_level._pieces.draw();
		super.draw();
			for (p in _players)
		{
			p.draw();
		}
		
		for (c in _level._amminutionpacks)
		{
			c.draw();
		}
		
		_level._shots.draw();
		
		
		_gi.draw();
		
		_effects.draw();
		
		_timerText.draw();
	}
	
	public function spawnShot ( s : Shot) : Void 
	{
		_level._shots.add(s);
	}
	
	public function spawnHit (s : Shot) : Void 
	{
		var e : FlxSprite  = new FlxSprite(s.x, s.y);
		e.loadGraphic(AssetPaths.gfx_shot_impact_sheet__png, true, 32, 32, false);
		var fps : Int = 6;
		
		e.animation.add("idle", [0, 1], fps, false);
		e.animation.play("idle");
		e.scale.x = 0.25;
		e.scale.y = 0.25;
		
		var totTime : Float = 2.0 / fps;
		var halfTime : Float = totTime / 2.0;
		var fadeout : Float = halfTime ;
		FlxTween.tween(e, { alpha : 0 }, fadeout, { startDelay : halfTime, onComplete : { function(t) { e.alive = false; }} } );
		FlxTween.tween(e.scale, { x : 2, y: 2 }, halfTime*0.99, { startDelay : 0.0, onComplete : { function(t) { e.scale.set(0.75, 0.75);}} } );
		FlxTween.tween(e.scale, { x : 1.5, y: 1.5 }, fadeout, { startDelay : halfTime} );
		
		_effects.add(e);
	}
	
	function cleanEffects() 
	{
		var elist : FlxSpriteGroup = new FlxSpriteGroup();
		for (e in _effects)
		{
			if (e.alive) elist.add(e);
		}
		
		_effects = elist;
	}
	

}

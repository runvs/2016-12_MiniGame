package;

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
using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{

	private var _players : FlxTypedGroup<Player>;
	private var _level : Level;
	private var _gi : GameInterface;
	
	private var _startPlayers : Array<String>;
	
	private var _effects : FlxSpriteGroup;
	
	private var _timer : Float = 0;
	
	private var _timerText : FlxText;
	
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
		
		_timerText = new FlxText(0, 0, 0, "", 16);
		_timerText.screenCenter(FlxAxes.X);
		_timerText.y = 16;
		
		
		
	}

	override public function update(elapsed:Float):Void
	{
		cleanEffects();
		_level.cleanShots();
		
		super.update(elapsed);
		
		FlxG.collide(_players, _players);
		
		for (p in _players)
		{
			p.update(elapsed);
		}
		_level._shots.update(elapsed);
		
		for (p in _players)
		{
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
	
	override public function draw () : Void 
	{
		super.draw();
			for (p in _players)
		{
			p.draw();
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

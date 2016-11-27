package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;


class PlayState extends FlxState
{

	private var _players : FlxTypedGroup<Player>;
	private var _level : Level;
	private var _gi : GameInterface;
	
	private var _startPlayers : Array<String>;
	
	public function new ()
	{
		super();
		_startPlayers = new Array<String>();
	}
	
	public function addPlayer(name : String)
	{
		_startPlayers.push(name);

	}
	
	
	override public function create():Void
	{
		super.create();
		
		
		
		_players = new FlxTypedGroup<Player> ();
		_gi = new GameInterface();
		
		for (i in 0 ... _startPlayers.length)
		{
			var p : Player = new Player();
			p.setState(this, String2BasicInput.get(_startPlayers[i]), i);
			_players.add(p);
			_gi.addPlayer(p, 750, 80);
		}
		
		_level = new Level();
	}

	override public function update(elapsed:Float):Void
	{
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
					FlxObject.separate(p, s);
					s.alive = false;
					p.hit();
				}
			}
		}
		_gi.update(elapsed);
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
	}
	
	public function spawnShot ( s : Shot) : Void 
	{
		_level._shots.add(s);
	}
	
}

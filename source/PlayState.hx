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
	
	override public function create():Void
	{
		super.create();
	
		_players = new FlxTypedGroup<Player> ();
		
		var p0 : Player = new Player();
		p0.setState(this, new InputKeyboard1(), 0);
		_players.add(p0);
		
		var p1 : Player = new Player();
		p1.setState(this, new InputKeyboard2(), 1);
		_players.add(p1);

		var p3 : Player = new Player();
		p3.setState(this, new GPInput(0), 2);
		_players.add(p3);
		
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
	}
	
	override public function draw () : Void 
	{
		super.draw();
			for (p in _players)
		{
			p.draw();
		}
		_level._shots.draw();
	}
	
	public function spawnShot ( s : Shot) : Void 
	{
		_level._shots.add(s);
	}
	
}

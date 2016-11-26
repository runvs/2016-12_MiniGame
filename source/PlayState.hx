package;

import flixel.FlxG;
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

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		for (p in _players)
		{
			p.update(elapsed);
		}
	}
	
	override public function draw () : Void 
	{
		super.draw();
			for (p in _players)
		{
			p.draw();
		}
	}
}

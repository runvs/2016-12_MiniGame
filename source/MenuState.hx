package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	private var _text : FlxText;
	private var t : Float = 0;
	//
	//private var arr : Array<Int> = new Array<Int>();
	//private var map : Map<Int, String> = new Map<Int,String>();
	//
	//
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		_text = new FlxText( 100, 100, 0, "My Game, press Space to start", 16);
		add(_text);
		//arr.push(2);
		//arr.push(15);
		
		//for (i in 0 ... arr.length)
		//{
			//arr[i] += 2;
		//}
		//
		//for ( f in arr)
		//{
			//
		//}
		//
		//map.set(4, "bla");
		//map.get(4);
		
		//for (k in map.keys)
		//{
			//map.get(k);
		//}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		t += elapsed;
		//_text.update(elapsed);
		if (FlxG.keys.pressed.SPACE)
		{
			FlxG.switchState(new PlayState());
		}
		_text.angle = t * 100;
		_text.x = 200 * Math.sin(t);
	}
	
	override public function draw():Void
	{
		super.draw();
		//_text.draw();
	}
}

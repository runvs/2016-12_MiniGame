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
	//
	//private var arr : Array<Int> = new Array<Int>();
	//private var map : Map<Int, String> = new Map<Int,String>();
	//
	//
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		GP.PCols = new PlayerColors();
		//_startText = new FlxText( 100, 100, 0, "pushover, press Space to start", 16);
        // contains the "player<x>: press A to join" messages
        //_playerText = new Array<String>();
		//add(_startText);
        //add(_playerText);	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.SPACE)
		{
			FlxG.switchState(new PlayState());
		}
	}
	
	override public function draw():Void
	{
		super.draw();
		//_text.draw();
	}
}

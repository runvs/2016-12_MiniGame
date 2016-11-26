package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _spr : FlxSprite;
	
	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.RED;
		
		_spr = new FlxSprite();
		_spr.makeGraphic(32, 32, FlxColor.WHITE);
		add(_spr);
		
		_spr.pixels.setPixel32(15, 15, FlxColor.BLUE);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

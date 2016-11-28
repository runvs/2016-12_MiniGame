package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class Crate extends FlxSprite
{
	var _glowoverlay : FlxSprite;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		_glowoverlay = new GlowOverlay(0, 0, FlxG.camera, Std.int(Math.max(this.width * 2, this.height * 2)), 1, 1);
		_glowoverlay.color = FlxColor.fromRGB(133,193,255);
		//_glowoverlay.blend = BlendMode.ADD;
		//_glowoverlay.alpha = 0.5;
	}
	
	
	public override function draw ()
	{
		//trace("crate.draw");
		_glowoverlay.x = x + width/2;
		_glowoverlay.y = y + height/2;
		
		super.draw();
		_glowoverlay.draw();
	}
}
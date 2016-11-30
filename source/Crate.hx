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
	
	public var _type : Bool  = false; // false means ammu, true means health
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		this.loadGraphic(AssetPaths.gfx_ammo__png, false, 32, 32);
		_glowoverlay = new GlowOverlay(0, 0, FlxG.camera, Std.int(Math.max(this.width * 2, this.height * 2)), 1, 1);
		_type = FlxG.random.bool();
		if (_type)
		{
			_glowoverlay.color = FlxColor.fromRGB(90, 100, 255);
		}	
		else 
		{
			_glowoverlay.color = FlxColor.fromRGB(255, 100, 90);
		}
		_glowoverlay.blend = BlendMode.ADD;
		_glowoverlay.alpha = 0.5;
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
package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Vignette extends FlxSprite
{
	var _cam : FlxCamera;

	public function new(c:FlxCamera, maxAlpha : Float = 0.45, rangescale : Float = 0.9, exponent : Float = 2) 
	{
		super();
		
		_cam = c;
		
		this.makeGraphic(_cam.width, _cam.height, FlxColor.BLACK, true);
		var distmax = Math.sqrt(this.width * this.width / 4 + this.height * this.height / 4);
		for (i in 0... Std.int(this.width))
		{
			for (j in 0... Std.int(this.height))
			{
				var dx = this.width / 2 - i;
				var dy = this.height / 2 - j;
				var dist = dx * dx + dy * dy;
				var a = Math.pow(dist / distmax / distmax / rangescale / rangescale, exponent);
				a = Math.min(a, 1);
				if ( i == j)
				{
					//trace((dist / distmax / distmax / rangescale / rangescale) + " " + a);
				}
				#if !neko
				this.pixels.setPixel32(i, j, FlxColor.fromRGBFloat(0, 0, 0, a));
				#else
				a = a * 255;
				this.pixels.setPixel32(i, j, FlxColor.fromRGB(0,0,0,Std.int(a)));
				#end
			}
		}
		this.cameras = [_cam];
		this.scrollFactor.set();
		this.alpha = maxAlpha;
	}
	
}
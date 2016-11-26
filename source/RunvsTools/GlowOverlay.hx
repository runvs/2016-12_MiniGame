package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class GlowOverlay extends FlxSprite
{

	var _cam : FlxCamera;
	
	// x and y in Coordinates
	public function new(X:Float = 0, Y:Float = 0, c: FlxCamera, s: Int, rangescale : Float, exponent:Float) 
	{
		super(X, Y);
		
		_cam = c;
		
		this.makeGraphic(s, s, FlxColor.WHITE, true);
		this.offset.set(s / 2, s / 2);
		var distmax = s/2;// Math.sqrt(this.width * this.width / 4 + this.height * this.height / 4);
		for (i in 0... Std.int(this.width))
		{
			for (j in 0... Std.int(this.height))
			{
				var dx = this.width / 2 - i;
				var dy = this.height / 2 - j;
				var dist = dx * dx + dy * dy;
				var a = 1.0 - Math.pow(dist / distmax/distmax / rangescale/rangescale, exponent);
				this.pixels.setPixel32(i, j, FlxColor.fromRGBFloat(1,1,1, a));
			}
		}
		this.cameras = [_cam];
	}
	
}
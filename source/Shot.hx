package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.display.BlendMode;
/**
 * ...
 * @author 
 */
class Shot extends FlxSprite
{
	
	public var firedBy : Int = 0;
	
	private var _t : Float = 0;
	
	
	var _glowoverlay : FlxSprite;

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.gfx_char_shot__png, false, 64, 16, true);
		_glowoverlay = new GlowOverlay(0, 0, FlxG.camera, Std.int(Math.max(this.width * 2, this.height * 2)), 1, 1);
		_glowoverlay.blend = BlendMode.ADD;
		_glowoverlay.alpha = 0.25;
		_glowoverlay.scale.set(1, 0.25);
	}
	
	
	public override function update ( elapsed : Float ) : Void 
	{
		super.update(elapsed);
		
		
		_t += elapsed;
		
		var f : Float = (1 + Math.sin(Math.pow(8, Math.sin(_t))))/2;
		if (f < 0 ) f = 0;
		if ( f > 1) f = 1;
		this.alpha =  0.75 + 0.25 * f;
		
		if (_t > 2) alive = false; 
	}
	public function colorMe(id:Int) 
	{
		firedBy = id;
		this.color = GP.PCols.get(id);
		_glowoverlay.color = this.color;
	}
	
	public override function draw()
	{
		_glowoverlay.x = x + width/2;
		_glowoverlay.y = y + height / 2;
		_glowoverlay.angle = this.angle;
		_glowoverlay.draw();
		super.draw();
	}
	
}

package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Shot extends FlxSprite
{
	
	public var firedBy : Int = 0;
	
	private var _t : Float = 0;

	public function new() 
	{
		super();
		loadGraphic(AssetPaths.gfx_char_shot__png, false, 64, 16, true);
		
		
		
	}
	
	
	public override function update ( elapsed : Float ) : Void 
	{
		super.update(elapsed);
		
		_t += elapsed;
		
		var f : Float = (1 + Math.sin(Math.pow(8, Math.sin(_t))))/2;
		if (f < 0 ) f = 0;
		if ( f > 1) f = 1;
		this.alpha =  0.75 + 0.25 * f;
	}
	public function colorMe(id:Int) 
	{
		firedBy = id;
		this.color = GP.PCols.get(id);
	}
	
}

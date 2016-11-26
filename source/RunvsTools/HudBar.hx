package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class HudBar extends FlxSprite
{

	var _vertical : Bool;
	public var _background : FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, w : Float, h : Float, vertical: Bool =true) 
	{
		super();
		x = X;
		y = Y;
		_vertical = vertical;
		if (w < 0) w *= -1;
		if (h < 0) h *= -1;
		makeGraphic(Std.int(w), Std.int(h), FlxColor.WHITE);
		this.origin.set(0, 0);
		//this.scrollFactor.set();
		cameras = [GP.CameraMain];
		
		_background = new FlxSprite(x-1,y-1);
		_background.makeGraphic(Std.int(w) + 2, Std.int(h) + 2, FlxColor.GRAY);
		_background.alpha = 0.75;
		//_background.scrollFactor.set();
		_background.cameras = [GP.CameraMain];
	}
	
	override public function update(elapsed):Void
	{
		super.update(elapsed);
		var val : Float = health ;
		if (val < 0 ) val = 0;
		if (val > 1) val = 1;
			
		if (_vertical)
		{
			scale.set(1, val);
		}
		else
		{
			scale.set(val, 1);
		}
	}
	
	public function setBarPosition (X : Float, Y: Float )
	{
		this.setPosition(X, Y);
		_background.setPosition(X-1, Y-1);
	}
	
	public override function draw() : Void 
	{
		if (health != 0)
		{
			_background.draw();
		}
		super.draw();
	}
	
}
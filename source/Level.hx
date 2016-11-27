package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author 
 */
class Level
{
	
	public var _shots : FlxTypedGroup<Shot>;

	public var _pieces : FlxSpriteGroup;
	
	public var _radius : Float = 0;
	
	
	public function new() 
	{
		_shots = new FlxTypedGroup<Shot>();
	}
	
	public function cleanShots() 
	{
		var slist : FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
		for (s in _shots)
		{
			if (s.alive) slist.add(s);
		}
		
		_shots = slist;
		
		_pieces = new FlxSpriteGroup();
		
		var circle  : FlxSprite = new FlxSprite(0, 0);
		circle.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

		_radius = Math.min(circle.width / 2, circle.height / 2) * 0.85;
		circle.drawCircle(circle.width / 2, circle.height / 2, _radius, FlxColor.WHITE);
		_pieces.add(circle);
	}
	
}
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
	
	public var _amminutionpacks : FlxSpriteGroup;
	
	
	public function new() 
	{
		_shots = new FlxTypedGroup<Shot>();
		_amminutionpacks = new FlxSpriteGroup();
		
		_pieces = new FlxSpriteGroup();
		
		var circle  : FlxSprite = new FlxSprite(0, 0);
		//circle.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		circle.loadGraphic(AssetPaths.gfx_arena__png, false, 600, 600);
		circle.offset.set (300, 300);
		circle.x = FlxG.width / 2;
		circle.y = FlxG.height/ 2;

		_radius = Math.min(circle.width / 2, circle.height / 2);
		_pieces.add(circle);
	}
	
	public function cleanShots() 
	{
		var slist : FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
		for (s in _shots)
		{
			if (s.alive) slist.add(s);
		}
	
		_shots = slist;
	}
	public function cleanAmmu() 
	{
		var alist : FlxSpriteGroup = new FlxSpriteGroup();
		for (a in _amminutionpacks)
		{
			if (a.alive) alist.add(a);
		}
	
		_amminutionpacks = alist;
	}
		
}
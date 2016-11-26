package;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author 
 */
class Level
{
	
	public var _shots : FlxTypedGroup<Shot>;

	
	
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
	}
	
}
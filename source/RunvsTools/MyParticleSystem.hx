package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class MyParticleSystem extends FlxSpriteGroup
{

	// maximum number of Particles in this Particle System.
	// making this larger will have an impact on performance
	public var mySize : Int;
	
	// index, which particle is the next active one (used for recycling particles)
	private var _idx : Int;
	public function new() 
	{
		super();
		mySize = 100;
		_idx = 0;
	}

	public function Spawn(n: Int, setup : FlxSprite->Void, init : FlxSprite-> Void)
	{
		//trace("spawn particles");
		
		var leftToDo : Int = n;
		
		if (this.length < mySize)	// have not pushed mySize particles in
		{
			// fist check if there are dead ones
			while (leftToDo >= 0)
			{
				if (this.countDead() == 0)
					break;
				var s : FlxSprite = this.getFirstDead();
				if (s == null) break;
				setup(s);
				
				leftToDo -= 1;
			}
			
			// if not, push some new ones in
			for (i in 0...leftToDo)
			{
				
				var s : FlxSprite = new FlxSprite();
				init(s);
				setup(s);
				this.add(s);
				if (this.length >= mySize)
					break;
			}
		}
		else
		{			
			// list is full. first, get dead ones
			while (leftToDo >= 0)
			{
				if (this.countDead() == 0)
					break;
				var s : FlxSprite = this.getFirstDead();
				if (s == null) break;
				setup(s);
				
				leftToDo -= 1;
			}
			
			while (leftToDo >= 0)
			{
				var s : FlxSprite = this.members[_idx];
				_idx++;
				leftToDo--;
				if (_idx == this.length -1)
					_idx = 0;
				setup(s);
			}
		}
	}
	
	}
package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
    
	public function new()
	{
		super();
		addChild(new FlxGame(GP.ScreenWidth, GP.ScreenHeight, MenuState, 1, 60, 60, true));
	}
}

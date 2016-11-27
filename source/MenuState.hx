package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;

class MenuState extends FlxState
{
	private var _gameTitle : FlxText;
    private var _gameSubtitle : FlxText;
    // _playerTexts contains the text "player <i>: press any key to join" -> if player presses any key, change this text
 
	
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
        
     
        // tasty spaghetti incoming!
		_gameTitle = new FlxText(0, GP.fontSize(2), GP.ScreenWidth, "pushover\n", GP.fontSize(2));
        _gameSubtitle = new FlxText(0, GP.fontSize(2)*2.3, GP.ScreenWidth, "Press space to start", GP.fontSize(6));
	    _gameTitle.alignment = "center";	
        _gameSubtitle.alignment = "center";

        var format : FlxTextFormat= new FlxTextFormat(0xD81B60);

        var subtitleFormat : FlxTextFormat = new FlxTextFormat(0x00bcd4);
        _gameTitle.font = "assets/data/MECHAG.TTF";
        _gameTitle = _gameTitle.addFormat(format, -1, -1);
        _gameSubtitle = _gameSubtitle.addFormat(subtitleFormat, 6, 11 );
        _gameSubtitle.font = "assets/data/MECHAG.TTF";
         add(_gameTitle);
         add(_gameSubtitle);

	}

	override public function update(elapsed:Float):Void
	{
	   super.update(elapsed);
	}
	
	override public function draw():Void
	{
		super.draw();
	}
}

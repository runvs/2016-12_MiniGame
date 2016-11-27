package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;

class StartScreen extends FlxState
{
	private var _gameTitle : FlxText;
    private var _gameSubtitle : FlxText;
    // _playerTexts contains the text "player <i>: press any key to join" -> if player presses any key, change this text
    private var _playerTexts : Array<FlxText> = new Array<FlxText>();
  	private var t : Float = 0;
    private var input : Array<BasicInput>; 
	
	private var _timerText : FlxText; 
	private var _timer : Float = 120;
	
    
    // the next player to join
    private var nextToJoin : Int  = 0;
    private var refractory : Float = 0;
    private var alreadyJoined : Array<Bool> = new Array<Bool>();
	//private var arr : Array<Int> = new Array<Int>();
	//private var map : Map<Int, String> = new Map<Int,String>();
	//
	//
	
	public function getNumberOfPlayersJoined() : Int
	{
		var numberOfJoinedPlayers : Int = 0;
		for (b in alreadyJoined)
		{
			if (b) numberOfJoinedPlayers += 1;
		}
		
		return numberOfJoinedPlayers;
	}
	
	override public function create():Void
	{
		super.create();
        
        // add the FlxText objects to _playerTexts
        for (player in 0 ... 4) {
            _playerTexts.push(new FlxText(0, 300 + player*30 , GP.ScreenWidth, 'P${player + 1}: Press any key to join', GP.fontSize(7)));
            _playerTexts[player].alignment = "center";
        }

        trace('$_playerTexts[0]');
		FlxG.mouse.visible = false;
        
        input = new Array<BasicInput>();
        input.push(new InputKeyboard1());
        input.push(new InputKeyboard2());
        for (i in 0 ... 4) {
            input.push(new GPInput(i));
        }
        // used to check if specific player has already joined
        for (i in 0 ... input.length) {
           alreadyJoined.push(false);
        }

        // tasty spaghetti incoming!
		_gameTitle = new FlxText(0, GP.fontSize(2), GP.ScreenWidth, "pushover\n", GP.fontSize(2));
        _gameSubtitle = new FlxText(0, GP.fontSize(2)*2.3, GP.ScreenWidth, "Press SPACE to start", GP.fontSize(6));
	    _gameTitle.alignment = "center";	
        _gameSubtitle.alignment = "center";

        var format : FlxTextFormat= new FlxTextFormat(0xD81B60);
        var subtitleFormat : FlxTextFormat = new FlxTextFormat(0x00bcd4);
        _gameTitle = _gameTitle.addFormat(format, -1, -1);
        _gameSubtitle = _gameSubtitle.addFormat(subtitleFormat, 6, 11 );
         add(_gameTitle);
         add(_gameSubtitle);
        
         
         for (player in _playerTexts) {
            add(player);
         }
         // add the players
		GP.PCols = new PlayerColors();

		
		_timerText = new FlxText(0, 500, 0, 
		"Game Time: " + Std.string(Std.int(_timer)) + " [PgnUp], [PgnDwn]", 
		16);
		_timerText.screenCenter(FlxAxes.X);
		
		add(_timerText);
	}

	override public function update(elapsed:Float):Void
	{
	   super.update(elapsed);
        t += elapsed * 8;
		
		_timerText.text = "Game Time: " + Std.string(Std.int(_timer)) + " [PgnUp], [PgnDwn]";
		
		if (FlxG.keys.justPressed.PAGEUP)
		{
			_timer += 5;
			if (_timer >= 600) _timer = 600;
		}
		if (FlxG.keys.justPressed.PAGEDOWN)
		{
			_timer -= 5;
			if (_timer <= 30) _timer = 50;
		}
		
		
       // nice shiat
       _gameSubtitle.size = Std.int(GP.fontSize(6) - 4 * Math.sin(t));
        
        for (i in 0 ... input.length) {
            input[i].update(elapsed);
            if (alreadyJoined[i] == true) {
                continue;
            }
            if (input[i].anyPressed) {
                _playerTexts[nextToJoin].text = input[i].name + " joined";
                nextToJoin += 1;
                alreadyJoined[i] = true;
            }
        }
		if (FlxG.keys.pressed.SPACE)
		{
			if (getNumberOfPlayersJoined() >= 2)
			{				
				var p : PlayState = new PlayState();
				for (i in 0 ... alreadyJoined.length) {
				   if (alreadyJoined[i]) {
						p.addPlayer(input[i].name);
				   } 
				}

				p.setTimer(_timer);
				FlxG.switchState(p);
			}
		}
	}
	
	override public function draw():Void
	{
		super.draw();
		//_text.draw();
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

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
	
    private var alreadyJoined : Array<Bool> = new Array<Bool>();

    // for keyboards without numpad: keeps track of wether the user choose the shittyinputmode by pressing ENTER
    private var shittyInput : Array<BasicInput>;
    private var _shittyInputMode : Bool = false;
    private var _inputModeIndication : FlxText; 
	private var _infoText : FlxText;
	
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

        //trace('$_playerTexts[0]');
		FlxG.mouse.visible = false;
        
        input = new Array<BasicInput>();
        // for laptops without numpad: if shittyInputMode is true, change the InputKeyboard instances to InputShittyKeyboard instances
        // (which are stored in the shittyInput array)
        shittyInput = new Array<BasicInput>();

        input.push(new InputKeyboard1());
        input.push(new InputKeyboard2());
        shittyInput.push(new InputShittyKeyboard1());
        shittyInput.push(new InputShittyKeyboard2());

        for (i in 0 ... 4) {
            input.push(new GPInput(i));
        }
        // used to check if specific player has already joined
        for (i in 0 ... input.length) {
           alreadyJoined.push(false);
        }

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
         
         for (player in _playerTexts) {
            add(player);
            // change
//            player.font = "assets/data/MECHAG.TTF";
         }
         // add the players
		GP.PCols = new PlayerColors();

		
		_timerText = new FlxText(0, 500, 0, 
		"Game Time: " + Std.string(Std.int(_timer)) + " [PgnUp], [PgnDwn]", 
		16);
		_timerText.screenCenter(FlxAxes.X);
		
		add(_timerText);
		
		_infoText = new FlxText(10, 650, 800,
	"Created for MiniGameJam in November 2016 by\nThomas Wellmann (graphics), Aldo Brießmann (code),\nStefan Wolf (code), Jonas (code) and Simon Weis (code)\nThe font 'jungle life' by dj urban mecha from dafont.com, BGM videogame2 produced by DL Sounds.", 
		8);
		_infoText.color = FlxColor.GRAY;
		//_infoText.font = "assets/data/MECHAG.TTF";
		add(_infoText);
        
        // displays the input mode (shitty or normal)
        _inputModeIndication = new FlxText(10, 10, FlxG.width, "", 7);
        _inputModeIndication.alignment = "left";
        _inputModeIndication.color = FlxColor.GRAY;
        
        add(_inputModeIndication);
    
     if (FlxG.sound.music == null)  {
        FlxG.sound.playMusic("assets/music/Videogame2.wav", 1, true);
     }
	}

	override public function update(elapsed:Float):Void
	{
	   super.update(elapsed);
        t += elapsed * 8;
		
		_timerText.text = "Game Time: " + Std.string(Std.int(_timer)) + (!_shittyInputMode ? " inc: [PgnUp], dec: [PgnDwn]" : " inc: [1],  dec: [2]");
		
		if (FlxG.keys.justPressed.PAGEUP || FlxG.keys.justPressed.ONE)
		{
			_timer += 5;
			if (_timer >= 600) _timer = 600;
		}
		if (FlxG.keys.justPressed.PAGEDOWN || FlxG.keys.justPressed.TWO)
		{
			_timer -= 5;
			if (_timer <= 30) _timer = 30;
		}
		
		
       _gameSubtitle.size = Std.int(GP.fontSize(6) - 4 * Math.sin(t));

        // enable shitty input mode
        if (FlxG.keys.justPressed.ENTER) { //&& getNumberOfPlayersJoined() == 0) {
            _shittyInputMode = !_shittyInputMode;
        }       
        // handle shitty input mode
        if (_shittyInputMode) {
            _inputModeIndication.text = "Slightly shitty Keyboard Controls:\n{move: arrows, shoot: space}\n{movep2: wasd, shootp2: shift}\n(press Enter to toggle)";
            // only the first two objects of input (the keyboardInput instances) are affected by shitty input mode
            if (alreadyJoined[0]) {
                input[0] = new InputShittyKeyboard1();//shittyInput[0];
            }
            if (alreadyJoined[1]) {
                 input[1] = new InputShittyKeyboard2();//shittyInput[1];
            }

        } else {
            _inputModeIndication.text = "Normal Keyboard Controls:\n(p1) move: arrows; shoot: numpad\n(p2) move : wasd; shoot: ijkl\n(press Enter to toggle)";
            if (alreadyJoined[0]) {
                input[0] = new InputKeyboard1();
            }
            if (alreadyJoined[1]) {
                input[1] = new InputKeyboard2();
            }
        }
     

        for (i in 0 ... input.length) {
            input[i].update(elapsed);
            if (alreadyJoined[i]) {
                 _playerTexts[i].text = input[i].name + " joined";
                    
            } else if (input[i].anyPressed) {
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

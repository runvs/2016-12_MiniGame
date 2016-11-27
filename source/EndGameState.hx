package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
/**
 * ...
 * @author 
 */
class EndGameState extends FlxState
{
    private  var _gameOverText : FlxText;
    private  var _gameOverSubtitle : FlxText;
    private  var _gameStats : FlxText;
    private  var t : Float = 0;
    private  var state : PlayState; 
    public function new(state : PlayState) {
        this.state = state; 
        super();
    }
	public override function create() : Void 

	{
        _gameOverText  = new FlxText(0, FlxG.height / 6, FlxG.width, "game over!", GP.fontSize(3));
        _gameOverText.alignment = "center";
        _gameOverText.font = "assets/data/MECHAG.ttf";
        
        var _gameOverTextFormat : FlxTextFormat = new FlxTextFormat(0xD81B60);
        _gameOverText.addFormat(_gameOverTextFormat);
       
        _gameOverSubtitle = new FlxText(0, GP.fontSize(2)*2.3, GP.ScreenWidth, "press space to restart\npress esc to quit", GP.fontSize(7));
        var subtitleFormat : FlxTextFormat = new FlxTextFormat(0x00bcd4);
        var subtitleFormat2 : FlxTextFormat = new FlxTextFormat(0xFF5722);

        _gameOverSubtitle = _gameOverSubtitle.addFormat(subtitleFormat, 6, 11 );
        _gameOverSubtitle = _gameOverSubtitle.addFormat(subtitleFormat2, 28, 32);
        _gameOverSubtitle.font = "assets/data/MECHAG.ttf";
        _gameOverSubtitle.alignment = "center";
        
        var playerTexts : Array<FlxText> = new Array<FlxText>;

        for (player in state._startPlayers) {
            // playerTexts.push(new Flx)
            trace("ASDF");
            trace(player);
        }

        add(_gameOverText);
        add(_gameOverSubtitle);
		super.create();
	}
	
	public override function update (elapsed : Float ) : Void 
	{
        t += elapsed *8;
        _gameOverSubtitle.size = Std.int(GP.fontSize(6) - 4 * Math.sin(t));

        if (FlxG.keys.pressed.SPACE) {
		    FlxG.switchState(new StartScreen());
        }
         
    }
	
}

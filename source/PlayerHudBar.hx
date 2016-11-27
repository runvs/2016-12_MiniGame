package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxObject;

class PlayerHudBar extends HudBar
{
    private var _player:Player;
    private var _damageCountText:FlxText;
    private var _bulletsText:FlxText;
    private var _bulletSymbol:FlxSprite;

    override public function new(p:Player, X:Float=0, Y:Float=0, w:Float, h:Float, vertical:Bool=true)
    {
        _player = p;
        // hit percentage
        _damageCountText = new FlxText(X-50, Y, 90, "0%", 20);
        _damageCountText.font = "assets/data/MECHAG.TTF";
        _damageCountText.setBorderStyle(SHADOW, 0xFF000000, 4, 1);
        _damageCountText.wordWrap = false;
        _damageCountText.autoSize =false;
        _damageCountText.alignment = RIGHT;
        _damageCountText.color = 0xFFFFFF;

        // bullet symbol
        _bulletSymbol = new FlxSprite(X+5, Y+40, AssetPaths.gfx_char_shot__png);
        _bulletSymbol.angle = -90;
        _bulletSymbol.scale.y = 1.0;
        _bulletSymbol.scale.x = 0.5;

        // bullet number
        _bulletsText = new FlxText(X-60, Y+30, 90, "15", 20);
        _bulletsText.font = "assets/data/MECHAG.TTF";
        _bulletsText.setBorderStyle(SHADOW, 0xFF000000, 3, 1);
        _bulletsText.wordWrap = false;
        _bulletsText.autoSize =false;
        _bulletsText.alignment = RIGHT;
        _bulletsText.color = flixel.util.FlxColor.WHITE;

        super(X, Y, w, h, vertical);
		_background.color = GP.PCols.get(_player._ID);
    }

    // _barModulo is the maximum value for one health bar walkthrough
    static var _barModulo : Int = 100;
    static var _barMaxDamage : Int = 500;
    var _lastDamage : Float = -1.0;
    var _lastDamageTime : Float = 0.0; 

    override public function update(elapsed):Void
    {
        // calculate damage level (= color of damage bar) if it changed
        //TODO tune this a bit
        if (_lastDamage < _player._damageTrack || _player._damageTrack == 0)
        {

            var _damageLevel : Int = Std.int((1.0-((_player._damageTrack/_barMaxDamage)%1.0))*0xFF);
            var _barColor : Int = 0;
            if (_player._damageTrack < _barMaxDamage)
            {
                _barColor = 0x00FF0000+(_damageLevel<<8)+_damageLevel;
            } else
            {
                _barColor = 0x00FF0000;
            }
            _damageCountText.color = _barColor;
            health = (1+_player._damageTrack%_barModulo)/_barModulo;
            color = new FlxColor(_barColor);
            // update damage text
            _damageCountText.text = _player._damageTrack+"%";
            _lastDamage = _player._damageTrack;
            _lastDamageTime = 0.0;
        }

        if (_lastDamageTime < 0.1){
            _damageCountText.size = 23;
            _damageCountText.bold = true;
            _lastDamageTime += elapsed;
        } else if (_damageCountText.bold)
        {
            _damageCountText.size = 20;
            _damageCountText.bold = false;
        }

        _bulletsText.text = Std.string(_player._ammunition);

        super.update(elapsed);
    }

    override public function draw() : Void
    {
        super.draw();
        _damageCountText.draw();
        _bulletSymbol.draw();
        _bulletsText.draw();
        //trace(_bulletsText);
    }
}

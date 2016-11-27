package;

import flixel.util.FlxColor;
import flixel.text.FlxText;

class PlayerHudBar extends HudBar
{
    private var _player:Player;
    private var _damageCountText:FlxText;

    override public function new(p:Player, X:Float=0, Y:Float=0, w:Float, h:Float, vertical:Bool=true)
    {
        _player = p;
        //TODO set custom font
        _damageCountText = new FlxText(X-50, Y, 90, "0%", 20);
        _damageCountText.font = "assets/data/MECHAG.TTF";
        _damageCountText.setBorderStyle(SHADOW, 0xFF000000, 4, 1);
        _damageCountText.wordWrap = false;
        _damageCountText.autoSize =false;
        _damageCountText.alignment = RIGHT;
        _damageCountText.color = 0xFFFFFF;

       

        super(X, Y, w, h, vertical);
		 _background.color = GP.PCols.get(_player._ID);
    }

    // _barModulo is the maximum value for one health bar walkthrough
    static var _barModulo : Int = 100;
    var _lastDamage : Float = -1.0;
    var _lastDamageTime : Float = 0.0; 

    override public function update(elapsed):Void
    {
        // calculate damage level (= color of damage bar) if it changed
        //TODO tune this a bit
        if (_lastDamage < _player._damageTrack)
        {
            var _damageLevel : Int = Std.int((1.0-((_player._damageTrack/250)%1.0))*0xFF);
            var _barColor : Int = 0x00FF0000+(_damageLevel<<8)+_damageLevel;
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
        super.update(elapsed);
    }

    override public function draw() : Void
    {
        super.draw();
        _damageCountText.draw();
    }
}
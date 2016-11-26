package;

import flixel.util.FlxColor;

class PlayerHudBar extends HudBar
{
    private var _player:Player;

    override public function new(p:Player, X:Float=0, Y:Float=0, w:Float, h:Float, vertical:Bool=true)
    {
        _player = p; 
        super(X, Y, w, h, vertical);
    }

    override public function update(elapsed):Void
    {
        // _maxHealth is the maximum value for one health bar walkthrough
        var _maxHealth : Int = 100;
        // calculate damage level (= color of damage bar)
        //TODO tune this a bit
        var _damageLevel : Int = Std.int((1.0-((_player._damageTrack/500)%1.0))*0xFF);
        var _barColor : Int = 0xFF0000+(_damageLevel<<8)+_damageLevel;
        color = new FlxColor(_barColor);
        health = (1+_player._damageTrack%_maxHealth)/_maxHealth;
        super.update(elapsed);
    }
}
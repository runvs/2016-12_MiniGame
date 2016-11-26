package;


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
        var _maxHealth : Int = 100;
        //Sys.println(_player._damageTrack%_maxHealth);
        health = (_maxHealth-(_player._damageTrack%_maxHealth))/_maxHealth;
        super.update(elapsed);
    }
}
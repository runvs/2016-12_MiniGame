package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class GameInterface
{
    private var _healthBars : FlxTypedGroup<PlayerHudBar>;
    public function new()
    {
        _healthBars = new FlxTypedGroup<PlayerHudBar>();
    }

    public function draw() : Void
    {
        for (hb in _healthBars)
        {
            hb.draw();
        }
    }

    public function update(elapsed) : Void
    {
        for (hb in _healthBars)
        {
            hb.update(elapsed);
        }
    }

    public function addPlayer(p : Player, xpos:Float, ypos:Float) : Void
    {
        var HB : PlayerHudBar = new PlayerHudBar(p, xpos, ypos, 20.0, 50.0, true);
        HB.health = 1;
        _healthBars.add(HB);
    }
}
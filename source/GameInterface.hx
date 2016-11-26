package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class GameInterface
{
    static var horizScreenDistance:Float = 50.0;
    static var vertScreenDistance:Float = 80.0;

private var barPositions : Array<Array<Float>> = [
    [horizScreenDistance, vertScreenDistance],
    [FlxG.width - horizScreenDistance, vertScreenDistance],
    [FlxG.width - horizScreenDistance, FlxG.height - vertScreenDistance],
    [horizScreenDistance, FlxG.height - vertScreenDistance]
    ];
    private var _healthBars : FlxTypedGroup<PlayerHudBar>;
    public function new(playerList : Array<Player>)
    {
        _healthBars = new FlxTypedGroup<PlayerHudBar>();
        for (pNum in 0 ... playerList.length)
        {
            var xPos:Float = barPositions[pNum][0];
            var yPos:Float = barPositions[pNum][1];
            addPlayer(playerList[pNum], xPos, yPos);
        }
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

    /*
     * The addPlayer function is only public so it can be called when a player 
     * wants to join a running game.
     */
    public function addPlayer(p : Player, xpos:Float, ypos:Float) : Void
    {
        var HB : PlayerHudBar = new PlayerHudBar(p, xpos, ypos, 30.0, 50.0, true);
        HB.health = 1;
        _healthBars.add(HB);
    }
}
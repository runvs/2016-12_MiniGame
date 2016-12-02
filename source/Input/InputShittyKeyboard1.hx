package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputShittyKeyboard1 extends BasicInput
{
    // in case the player doesn't move and wants to shoot, shoot in the direction the player points	
    private var previousXVal : Float;	
    private var previousYVal : Float = 1;
	public function new() 
	{
        name = "wasd-shitty";		
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.A)
		{
			xVal = -1;
            this.previousXVal = xVal;
            this.previousYVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SHIFT) {
                xShootVal = -1;
            }
		}
		if (FlxG.keys.pressed.D)
		{            
			xVal = 1;
            this.previousXVal = xVal;
            this.previousYVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SHIFT) {
                xShootVal = 1;
            }
		}
		
		if (FlxG.keys.pressed.W)
		{
			yVal = -1;
            this.previousYVal = yVal;
            this.previousXVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SHIFT) {
                yShootVal = -1;
            }
		}
		if (FlxG.keys.pressed.S)
		{
			yVal = 1;
            this.previousYVal = yVal;
            this.previousXVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SHIFT) {
                yShootVal = 1;
            }
		}

        // in case the player doesn't move, we have to use the previous x/yVals for the new shootVal
        if (FlxG.keys.pressed.SHIFT && !FlxG.keys.pressed.S
            && !FlxG.keys.pressed.W && !FlxG.keys.pressed.A && !FlxG.keys.pressed.D){ 
            xShootVal = this.previousXVal;
            yShootVal = this.previousYVal;
        }
		
	}
	
}

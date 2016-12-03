package ;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class InputShittyKeyboard2 extends BasicInput
{
	private var previousXVal : Float;	
    private var previousYVal : Float = 1;

	public function new() 
	{
        name = "arrows-shitty";		
	}
	
	public override function update(elapsed : Float ) : Void
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.LEFT)
		{
			xVal = -1;
            this.previousXVal = xVal;
            this.previousYVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SPACE) {
                xShootVal = -1;
            }
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			xVal = 1;
            this.previousXVal = xVal;
            this.previousYVal = 0;
			anyPressed = true;
            if (FlxG.keys.pressed.SPACE) {
                xShootVal = 1;
            }
		}
		
		if (FlxG.keys.pressed.UP)
		{
			yVal = -1;
            this.previousYVal = yVal;
            this.previousXVal = 0;
                
			anyPressed = true;
            if (FlxG.keys.pressed.SPACE) {
                yShootVal = -1;
            }
		}
		if (FlxG.keys.pressed.DOWN)
		{
			yVal = 1;
            this.previousYVal = yVal;
            this.previousXVal = 0;

			anyPressed = true;
            if (FlxG.keys.pressed.SPACE) {
                yShootVal = 1;
            }
		}
		// in case the player doesn't move, we have to use the previous x/yVals for the new shootVal
        if (FlxG.keys.pressed.SHIFT && !FlxG.keys.pressed.UP
            && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.DOWN){ 
            xShootVal = this.previousXVal;
            yShootVal = this.previousYVal;
        }

	}
	
}

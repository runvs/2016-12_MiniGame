package ;

/**
 * ...
 * @author 
 */
class BasicInput
{
	public var xVal : Float = 0;
	public var yVal : Float = 0;
	
	public var anyPressed :Bool = false;
	
	public var xShootVal : Float = 0;
	public var yShootVal : Float = 0;

	public function update(elapsed: Float) : Void 
	{
		// reset the values
		xVal = 0;
		yVal = 0;
		xShootVal = 0;
		yShootVal = 0;
		anyPressed = false;
	}
}
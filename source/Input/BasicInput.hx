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

	public function update(elapsed: Float) : Void 
	{
		// reset the values
		xVal = 0;
		yVal = 0;
		anyPressed = false;

	}
}
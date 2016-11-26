package;

/**
 * ...
 * @author 
 */
class String2BasicInput
{

	public static function get(name : String ) : BasicInput
	{
		if (name == "wasd") return new InputKeyboard1();
		else if (name == "arrows") return new InputKeyboard2();
		else if (name == "gp 0") return new GPInput(0);
		else if (name == "gp 1") return new GPInput(1);
		else if (name == "gp 2") return new GPInput(2);
		else if (name == "gp 3") return new GPInput(3);
		else return null;
		
	}
	
}

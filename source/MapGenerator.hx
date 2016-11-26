import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.ds.Vector;

/* Very Basic Voronoi map Generator
 * To Generate a Map, must call Generate(sizeX, sizeY, points).
 */
class MapGenerator // extends FlxState
{
	private static var x : Int;
	private static var y : Int;
	private static var points : Array<FlxVector>;
	private static var colors : Array<FlxColor>;
	private static var sprite : FlxSprite;
	
	/* For Testing
	override public function create() : Void
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.RED;
		
		sprite = Generate(1024, 1024, 100);
		add(sprite);
	}
	/**/

	public static function Generate(sizeX:Int, sizeY:Int, pointAmount:Int) : FlxSprite
	{
		x = sizeX;
		y = sizeY;
		
		sprite = new FlxSprite();
		sprite.makeGraphic(x, y, FlxColor.WHITE);
		
		CreateRandomPoints(pointAmount);
		CreateRandomColors(pointAmount);
		DrawMap();

		return sprite;
	}
	
	private static function CreateRandomPoints(pointAmount : Int) : Void
	{
		points = new Array<FlxVector>();
		
		for (i in 0 ... pointAmount)
		{
			var randomPoint : FlxVector;
			randomPoint = new FlxVector(FlxG.random.float(0, x), FlxG.random.float(0, y));
			
			points.push(randomPoint);
		}
	}
	
	private static function CreateRandomColors(pointAmount : Int) : Void
	{
		colors = new Array<FlxColor>();
		
		for (i in 0 ... pointAmount)
		{
			colors.push(FlxG.random.color(FlxColor.WHITE, FlxColor.BLACK, 255, false));
		}
	}

	private static function DrawMap()
	{
		sprite.pixels.lock();
		
		for (ix in 0 ... x)
		{
			for (iy in 0 ... y)
			{
				var color : FlxColor;
				var coordinate : FlxVector;
				
				coordinate = new FlxVector(ix, iy);
				color = FindColorAtPoint(coordinate);
				ColorPixelOnSprite(coordinate, color);
			}
		}
		
		sprite.pixels.unlock();
	}
	
	private static function FindColorAtPoint(point : FlxVector) : FlxColor
	{
		var closestDistance : Float;
		var closestIndex : Int;
		
		closestDistance = Math.POSITIVE_INFINITY;
		closestIndex = 0;
		
		for (i in 0 ... points.length)
		{
			var currentDistance : Float;
			currentDistance = point.distanceTo(points[i]);
			if (currentDistance < closestDistance)
			{
				closestDistance = currentDistance;
				closestIndex = i;
			}
		}
		
		return colors[closestIndex];
	}
	
	private static function ColorPixelOnSprite(point : FlxVector, color : FlxColor)
	{
		sprite.pixels.setPixel32(Std.int(point.x), Std.int(point.y), color);
	}
}
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
import openfl.Vector.VectorDataIterator;

/* Very Basic Voronoi map Generator
 * To Generate a Map, must call Generate(sizeX, sizeY, points).
 * To access generated layers, use GetLayer(i) or GetLayers().
 */
class MapGenerator // extends FlxState
{
	private static var x : Int;
	private static var y : Int;
	private static var points : Array<FlxVector>;
	private static var colors : Array<FlxColor>;
	private static var sprite : FlxSprite;
	private static var layers : Array<FlxSprite>;
	
	/* For Testing
	override public function create() : Void
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.RED;
		
		sprite = Generate(512, 512, 100);
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
	
	public static function GetLayers() : Array<FlxSprite>
	{
		return layers;
	}
	
	public static function GetLayer(i : Int) : FlxSprite
	{
		if (i < layers.length)
		{
			return layers[i];
		}
		else
		{
			return null;
		}
	}
	
	// --------------
	// -- Privates --
	// --------------
	
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
		layers = new Array<FlxSprite>();
		
		for (i in 0 ... pointAmount)
		{
			colors.push(FlxG.random.color(FlxColor.WHITE, FlxColor.BLACK, 255, false));
			
			var layer : FlxSprite;
			layer = new FlxSprite();
			layer.makeGraphic(x, y, FlxColor.TRANSPARENT);			
			layers.push(layer);
		}
	}

	private static function DrawMap()
	{
		LockSprites();

		for (ix in 0 ... x)
		{
			for (iy in 0 ... y)
			{
				var colorIndex : Int;
				var coordinate : FlxVector;
				
				coordinate = new FlxVector(ix, iy);
				colorIndex = FindIndexOfNearestPoint(coordinate);
				ColorPixel(coordinate, colorIndex);
			}
		}
		
		UnlockSprites();
	}
	
	private static function LockSprites() : Void
	{
		sprite.pixels.lock();
		
		for (i in 0 ... layers.length)
		{
			layers[i].pixels.lock();
		}
	}

	private static function UnlockSprites() : Void
	{
		sprite.pixels.unlock();
		
		for (i in 0 ... layers.length)
		{
			layers[i].pixels.lock();
		}
	}
	
	private static function FindColorAtPoint(point : FlxVector) : FlxColor
	{
		var closestIndex : Int;
		closestIndex = FindIndexOfNearestPoint(point);
		
		return colors[closestIndex];
	}
	
	private static function FindIndexOfNearestPoint(point : FlxVector) : Int
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
		
		return closestIndex;
	}
	
	private static function ColorPixel(point : FlxVector, colorIndex : Int)
	{
		var color : FlxColor;
		color = colors[colorIndex];
		
		sprite.pixels.setPixel32(Std.int(point.x), Std.int(point.y), color);
		layers[colorIndex].pixels.setPixel32(Std.int(point.x), Std.int(point.y), color);
	}
}
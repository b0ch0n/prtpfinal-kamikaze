package entities.breakable;

import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

import flixel.util.FlxRandom;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class BoxNape extends FlxNapeSprite
{

	public function new(obj:TiledObject)
	{
		super(obj.x + obj.width/2.0, obj.y + obj.height/2.0);
		makeGraphic(obj.width, obj.height);
		createRectangularBody();
		loadGraphic(RandomDynamicIMG());
		antialiasing = true;

		// 1 _____ 128
		// x _____ width
		scale.x = obj.width / 128;
		scale.y = obj.height / 128;

		setBodyMaterial(0);
		body.mass = 2.5;
		body.align();
		#if debug
			body.debugDraw = true;
		#end
	}
	
	public function RandomDynamicIMG():Dynamic
	{
		var rand = FlxRandom.intRanged(2, 6);
		switch(rand)
		{
			case 2:return GC.IMG_breakable_2;
			case 3:return GC.IMG_breakable_3;
			case 4:return GC.IMG_breakable_4;
			case 5:return GC.IMG_breakable_5;
			case 6:return GC.IMG_breakable_6;
			default:return GC.IMG_breakable_2;
		}
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
}
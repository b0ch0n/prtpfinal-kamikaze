package entities.breakable;

import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxPoint;
import nape.dynamics.InteractionFilter;

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class LinkChain extends FlxNapeSprite
{
 //public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	public function new(obj:TiledObject)
	{
		//super(X, Y, ?SimpleGraphic, CreateRectangularBody, EnablePhysics);
		super(obj.x, obj.y);
		makeGraphic(25, 38);// (256, 384);
		createRectangularBody();
		loadGraphic(GC.IMG_link_chain);
		antialiasing = true;

		// 1 _____ 128
		// x _____ width
		scale.x = 0.1;//256/64
		scale.y = 0.1;//384/64

		setBodyMaterial(0);
		body.mass = 5.0;
		body.align();
		
		// filtro de collisionGroup y collisionMask para evitar
		//  que los eslabones de la cadena colisionen entre ellos
		body.setShapeFilters(new InteractionFilter(2, 1));
		
		#if debug
			body.debugDraw = true;
		#end
		//var strObj:String = obj.custom.resolve("points");
		//trace(strObj);
		
		var arrayPoints:Array<FlxPoint> = obj.points;
		trace(arrayPoints.toString());
	}
	
}
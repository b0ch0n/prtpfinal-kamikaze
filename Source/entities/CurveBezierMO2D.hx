package entities;

import flash.geom.Point;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class CurveBezierMO2D extends FlxObject
{	
	
	// Imagenes de los puntos de control y curva
	private var greenPoint : FlxSprite;
	private var redPoint : FlxSprite;

	// Array que contiene los puntos de control
	private var controlPoints : Array<flash.geom.Point>;
	// Array que contiene los puntos de la curva de bezier
	private var bezierPoints : Array<flash.geom.Point>;	
	private var duration : Int = 1;
	
	private var Q : Array<flash.geom.Point>;
	private var N:Int = 0;

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);

		greenPoint = new FlxSprite( x, y, GC.IMG_green_point_16);
		//greenPoint.setGraphicSize(40, 40);	
		//greenPoint.updateHitbox();
		greenPoint.centerOrigin();

		redPoint = new FlxSprite();// x, y);
		redPoint.loadGraphic(GC.IMG_red_point_32, true, 32, 32);
		//redPoint.loadGraphic("gfx/tnt.png", false, 160, 240);
		redPoint.centerOrigin();
		
		controlPoints = new Array<flash.geom.Point>();
		bezierPoints = new Array<flash.geom.Point>();
		Q = new Array<flash.geom.Point>();
		AddControlPoint(new flash.geom.Point(x, y));
	}

	/**
		* _ Agrega un punto de control de la curva en la posicion
		* _ indicada por el punto cp
		* */
	public function AddControlPoint(cp : flash.geom.Point):Void
	{
		controlPoints.push(cp);
		//trace("controlPoints.length = "+controlPoints.length);
	}
	
	public function LoadBezierPoints():Void
	{
		// borra todos los puntos guardados
		bezierPoints.splice(0, bezierPoints.length);
		
		var t:Float = 0.0;
		while (t <= duration)
		{
			bezierPoints.push(new flash.geom.Point(Calculate(t).x, Calculate(t).y));
			
			t += 0.05;
		}
		
		//for (bp in 0...bezierPoints.length)
		//{
			//trace("bezierPoints[bp] = "+bezierPoints[bp]);
		//}
	}
	
	override public function draw():Void
	{
		//super.draw();
		
		// dibujo cada punto de control
		for (cp in 0...controlPoints.length)
		{
			redPoint.setPosition(controlPoints[cp].x, controlPoints[cp].y);
			//redPoint.setPosition(controlPoints[cp].x - redPoint.width/2, controlPoints[cp].y - redPoint.height/2);
			redPoint.draw();
		}

		// si hay mas de 1 punto de control
		if (controlPoints.length > 1)
		{
			// dibujo el recorrido de la curva de bezier
			for (p in 0...bezierPoints.length)
			{
				//greenPoint.setPosition(bezierPoints[p].x, bezierPoints[p].y);
				greenPoint.setPosition(bezierPoints[p].x - greenPoint.width/2, bezierPoints[p].y - greenPoint.height/2);
				
				greenPoint.draw();
			}
		}		
	}

	/**
		* _ Calcula la posicion sobre la curva en el tiempo "t"
		* */
	public function Calculate(t : Float):flash.geom.Point
	{
		N = controlPoints.length;
		
		for (i in 0...N)
		{
			Q.push(new flash.geom.Point(controlPoints[i].x,controlPoints[i].y)); // primera columna de la cunia
			//trace("controlPoints[i] = "+controlPoints[i]+"          Q[i] = "+Q[i]);
		}
		
		for (k in 1...N)//por cada columna siguiente de la cunia
		{
			for (i in 0...(N-k))
			{
						Q[i].x = (1 - t) * Q[i].x + t * Q[i + 1].x;//calculo del punto C en el ratio (1-t):t
						Q[i].y = (1 - t) * Q[i].y + t * Q[i + 1].y;
			}
		}
		
		var pc_t : flash.geom.Point = new flash.geom.Point(Q[0].x, Q[0].y);
		Q.splice(0, Q.length);
		
		return pc_t;
	}
	

}
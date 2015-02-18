package entities;

import flash.geom.Point;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;

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
	// Array que contiene las posiciones de los puntos de control
	private var redPointPositions : Array<flash.geom.Point>;
	
	// Array que contiene los puntos de la curva de bezier
	private var bezierPoints : Array<flash.geom.Point>;	
	// Array que contiene los puntos de un segmento cuando hay slowMotion
	private var slowMotionPoints : Array<flash.geom.Point>;	
	
	// Array que contiene las posiciones de los puntos de la curva de bezier
	private var greenPointPositions : Array<flash.geom.Point>;	
	
	private var duration : Int = 1;
	/**
	 * Delta del tiempo que hay entre un punto de la curva y otro
	 */
	private var delta_t_bezierPoints:Float = 0.05;
	
	private var Q : Array<flash.geom.Point>;
	private var N:Int = 0;

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);

		greenPoint = new FlxSprite( x, y, GC.IMG_green_point_16);

		redPoint = new FlxSprite(0, 0, GC.IMG_red_point_32);
		
		controlPoints = new Array<flash.geom.Point>();
		redPointPositions = new Array<flash.geom.Point>();
		bezierPoints = new Array<flash.geom.Point>();
		slowMotionPoints = new Array<flash.geom.Point>();
		greenPointPositions = new Array<flash.geom.Point>();
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
		redPointPositions.push(new flash.geom.Point(cp.x - redPoint.width * 0.5, cp.y - redPoint.height * 0.5));
		//trace("controlPoints.length = "+controlPoints.length);
	}
	

	public function LoadBezierPoints():Void
	{
		// borra todos los puntos guardados
		bezierPoints.splice(0, bezierPoints.length);
		greenPointPositions.splice(0, greenPointPositions.length);
		
		var t:Float = 0.0;
		var bp;
		while (t <= duration)
		{
			bp = Calculate(t);
			bezierPoints.push(bp);
			greenPointPositions.push(new flash.geom.Point(bp.x - greenPoint.width * 0.5, bp.y - greenPoint.height * 0.5));
						
			t += delta_t_bezierPoints;// 0.05;
		}
	}

	
	/*
	public function LoadSlowMotionPoints():Void
	{
		// vaciado del array que contiene los puntos
		slowMotionPoints.splice(0, slowMotionPoints.length);
		
		var t:Float = 0.0;
		var delta_t_slow_motion = FlxG.elapsed;// tiempo que se debe calcular entre el punto actual y el siguiente
		var smp;
		while (t <= delta_t_bezierPoints)
		{
			smp = CalculateSlowMotionPoint(t);
			slowMotionPoints.push(smp);
			
			t += delta_t_slow_motion;
		}
	}
	*/
	
	public function CalculateSlowMotionPoint(t : Float, points:Array<flash.geom.Point>):flash.geom.Point
	{
		N = points.length;
		
		for (i in 0...N)
		{
			Q.push(new flash.geom.Point(points[i].x,points[i].y)); // primera columna de la cunia
			//trace("points[i] = "+points[i]+"          Q[i] = "+Q[i]);
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
	
	override public function draw():Void
	{
		//super.draw();
		
		// dibujo cada punto de control
		for (cp in 0...controlPoints.length)
		{
			//redPoint.setPosition(controlPoints[cp].x - redPoint.width*0.5, controlPoints[cp].y - redPoint.height*0.5);
			redPoint.setPosition(redPointPositions[cp].x, redPointPositions[cp].y);
			redPoint.draw();
		}

		// si hay mas de 1 punto de control
		if (controlPoints.length > 1)
		{
			// dibujo el recorrido de la curva de bezier
			for (p in 1...bezierPoints.length)
			{
				//greenPoint.setPosition(bezierPoints[p].x - greenPoint.width*0.5, bezierPoints[p].y - greenPoint.height*0.5);
				greenPoint.setPosition(greenPointPositions[p].x, greenPointPositions[p].y);
				greenPoint.draw();
			}
		}		
	}

}
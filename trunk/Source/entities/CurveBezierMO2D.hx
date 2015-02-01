package entities;

import flash.geom.Point;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import lime.graphics.Image;
import openfl.display.Graphics;
import openfl.display.Sprite;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class CurveBezierMO2D extends FlxSprite
{	
	
	// Imagenes de los puntos de control y curva
	private var graphicPoint : FlxSprite;// Image;
	private var redPoint : FlxSprite;// Image;

	// Array que contiene los puntos de control
	private var controlPoints : Array<flash.geom.Point>;
	// Array que contiene los puntos de la curva de bezier
	private var bezierPoints : Array<flash.geom.Point>;	
	private var duration : Int = 1;
	
	private var Q : Array<flash.geom.Point>;
	private var N:Int = 0;
	
/*
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, ?SimpleGraphic);
		
	}
*/
	public function new(x:Float=0, y:Float=0, ?SimpleGraphic:Dynamic) //, graphic:Graphics=null, mask:mask=null) 
	{
		//super(x, y, graphic, mask);
		super(x, y);// , ?SimpleGraphic);
		//set_name("CurveBezierMO2D");
		
		
		//setHitbox(12, 23, 0, 0);
		setSize(12, 13);
		//Draw.setTarget(HXP.buffer, HXP.camera);
		
		//graphicPoint = new Image(ImageType.fromString(GC.IMG_green_point));
		//graphicPoint.centerOrigin();
		//graphicPoint.scale = 0.1;//0.04;
		graphicPoint = new FlxSprite(0, 0, GC.IMG_green_point);
		graphicPoint.centerOrigin();
		graphicPoint.setSize(10, 10);// .scale.set( 0.1, 0.1); // 0.04;
		
		
		//redPoint = new Image(ImageType.fromString(GC.IMG_red_point));
		//redPoint.centerOrigin();
		//redPoint.scale = 0.1;
		redPoint = new FlxSprite(0, 0, GC.IMG_red_point);
		redPoint.centerOrigin();
		//redPoint.setSize(0.5, 10);
		//redPoint.scale.set( 0.1, 0.1);
		
		
		controlPoints = new Array<flash.geom.Point>();
		Q = new Array<flash.geom.Point>();
		bezierPoints = new Array<flash.geom.Point>();
		AddControlPoint(new flash.geom.Point(x, y));
	}
	
	//public function destroy():Void
	//{
		//world.remove(this);
	//}
	
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
		super.draw();// .render();
		
		// dibujo cada punto de control

		for (cp in 0...controlPoints.length)
		{
			redPoint.draw();// .render(HXP.buffer, new flash.geom.Point( controlPoints[cp].x, controlPoints[cp].y), HXP.camera);
		}

		if (controlPoints.length > 1)
		{
			RenderCurve();
		}		
	}

	/**
		* _ Dibuja la curva de Bezier
		* _ longSegment = largo de los segmentos que trazan la curva
		* NOTA: Para que se dibuje tiene que tener 3 o mas puntos de control
		* */
	public function RenderCurve(longSegment:Int=0):Void
	{		
		// dibujo el recorrido de la curva de bezier
		for (p in 0...bezierPoints.length)
		{
			graphicPoint.draw();// .render(HXP.buffer, new flash.geom.Point(bezierPoints[p].x, bezierPoints[p].y), HXP.camera);
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
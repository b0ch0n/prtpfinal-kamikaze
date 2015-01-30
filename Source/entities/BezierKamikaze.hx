package entities;

import bezier.Bezier;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import deep.math.Point;
import com.haxepunk.utils.Draw;
import com.haxepunk.HXP;

enum PointBezier
{
	Start;
	Control;
	End;
}

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class BezierKamikaze extends Bezier// extends Graphic
{
	private var pointBezier : PointBezier = PointBezier.Start;
	
	//private var start:Point;
	private var control:Point;
	private var end:Point;
	
	private var duration : Float = 1.0;

	// para graficar el recorrido de la curva y los puntos que la forman
	private var graphicPoint : Image;
	private var redPoint : Image;
	private var greenPoint : Image;
	private var bluePoint : Image;
	
	// para guardar los puntos que recorren la curva de bezier
	private var bezierPoints : Array < flash.geom.Point>;
	

	/**
		*	Al llamar al constructor debo pasar el parametro start
		* que es el punto de inicio de cada curva de bazier
		* */
	public function new(?start:Point, ?control:Point, ?end:Point, isSegment=true) 
	{
		super(?start, ?control, ?end, isSegment);
		
		Draw.setTarget(HXP.buffer, HXP.camera);
		pointBezier = PointBezier.End;
	}
	
	public function LoadGraphicsPoints():Void
	{		
		graphicPoint = new Image(ImageType.fromString(GC.IMG_green_point));
		graphicPoint.centerOrigin();
		graphicPoint.scale = 0.04;
		
		redPoint = new Image(ImageType.fromString(GC.IMG_red_point));
		redPoint.centerOrigin();
		redPoint.scale = 0.1;

		greenPoint = new Image(ImageType.fromString(GC.IMG_green_point));
		greenPoint.centerOrigin();
		greenPoint.scale = 0.1;

		bluePoint = new Image(ImageType.fromString(GC.IMG_blue_point));
		bluePoint.centerOrigin();
		bluePoint.scale = 0.1;
	}
	
	override public function render():Void
	{

		// dibujo los puntos de inicio, control y final
		redPoint.render(HXP.buffer, new flash.geom.Point( myBezier.start.x, myBezier.start.y), HXP.camera);
		greenPoint.render(HXP.buffer, new flash.geom.Point( myBezier.control.x, myBezier.control.y), HXP.camera);
		bluePoint.render(HXP.buffer, new flash.geom.Point( myBezier.end.x, myBezier.end.y), HXP.camera);
		
		// dibujo el recorrido de la curva de bezier
		for (p in 0...bezierPoints.length)
		{
			graphicPoint.render(HXP.buffer, new flash.geom.Point(bezierPoints[p].x,bezierPoints[p].y), HXP.camera);
		}
		
	}
	
}
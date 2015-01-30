package entities;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tmx.TmxObject;
import deep.math.Const;
import haxe.Timer;
import deep.math.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import openfl.display.GraphicsPath;
import openfl.display.Graphics;

import flash.display.Graphics;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.haxepunk.utils.Draw;
import flash.geom.Point;

import bezier.Bezier;

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class Kamikaze extends Entity
{
	private var timeStep:Float = 0.005;
	private var timeBezier:Float = 0.0;
	private var angleBezier:Float = 0.0;
	
	private var spKamikaze : Spritemap;
	
	// variables para implementar con bezier
	private var myBezier : Bezier = null;
	private var startPoint : deep.math.Point;
	private var controlPoint : deep.math.Point;
	private var endPoint : deep.math.Point;
	private var bezierPoints : Array<flash.geom.Point>;
	private var duration:Float = 1.0;	
	
	private var graphicPoint : Image;
	private var redPoint : Image;
	private var greenPoint : Image;
	private var bluePoint : Image;		
	
	public function new(obj : TmxObject)
	{
		#if debug
			HXP.console.update();
		#end
		//super(obj.x, obj.y);
		super(200,200);
		
		spKamikaze = new Spritemap("gfx/kamikaze.png", 110, 48);//(GC.IMG_kamikaze, 109, 48);
		spKamikaze.add("flying", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 5);
		spKamikaze.play("flying");
		
		spKamikaze.centerOrigin();
		graphic = spKamikaze;
		Draw.setTarget(HXP.buffer, HXP.camera);
		
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

		// carga de puntos y curva
		startPoint = new deep.math.Point(200, 200);
		controlPoint = new deep.math.Point(700, 900);
		endPoint = new deep.math.Point(1200, 200);
		
		LoadBezier();
		
	}
	
	public function LoadBezier():Void
 {

		myBezier = new Bezier(startPoint, controlPoint, endPoint, false);
		//trace("myBezier.get_length() = " + myBezier.get_length());
		LoadBezierPoints();
	}
	
	public function LoadBezierPoints():Void
	{
		bezierPoints = new Array<flash.geom.Point>();
		var t = 0.0;
		while (t <= duration)
		{
			var p = myBezier.getPoint(t);
			bezierPoints.push(new flash.geom.Point(p.x,p.y));
			
			t += 0.05;
		}
	}

	override public function update():Void
	{
		super.update();

		#if debug
			if (Input.check(Key.R))
			 HXP.scene = new scenes.GameScene();
		#end

		// si el avion no esta en el final de la curva
		if (this._point.x != myBezier.end.x && this._point.y != myBezier.end.y)
		{
			MoveOnBezier();
		}
	}
	
	public function MoveOnBezier():Void
	{
		timeBezier += timeStep;
		if (timeBezier < duration)
		{
			var p = myBezier.getPoint(timeBezier);// obtengo el punto de la curva de bezier			
			moveTo(p.x, p.y);// muevo la entidad hacia el punto obtenido
			
			var r = myBezier.getTangentAngle(timeBezier);
			//  180-----PI*rad---> 1 rad = 180/PI
			//1 rad-----180/PI
			//r rad----- x grados-----> [ x grados = r * 180.0/PI ]
			//trace("r * Math.PI/180.0 = "+(-(r * 180.0/Math.PI)));
			spKamikaze.angle = - (r * 180.0/Math.PI);
		}
	}
	
	public function ViewData():Void
	{
		//trace("spKamikaze.x = "+this.x+"  spKamikaze.y = "+this.y);
	}
	
	override public function render():Void
	{		
		super.render();

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
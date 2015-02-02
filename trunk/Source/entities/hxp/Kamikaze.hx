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
 private var banzai:Bool = false;
	private var canRender:Bool = false;
	private var timeStep:Float = 0.005;
	private var timeBezier:Float = 0.0;
	private var angleBezier:Float = 0.0;
	//private var loadingBezier : Bool = true;
	
	private var spKamikaze : Spritemap;
	
	// variables para implementar con bezier
	private var myBezier : Bezier = null;
	private var nullPoint : deep.math.Point;
	private var start : deep.math.Point;
	private var control : deep.math.Point;
	private var end : deep.math.Point;
	private var bezierPoints : Array<flash.geom.Point>;
	
	private var duration:Float = 1.0;
	
	private var numCurves : Int = 3;
	private var countCurves : Int = 0;
	
	
	private var graphicPoint : Image;
	private var redPoint : Image;
	private var greenPoint : Image;
	private var bluePoint : Image;
	
	private var beziersKamikaze:Array < Bezier >;
	
	private var testValue : Float = 1.57425;
	
	public function new(obj : TmxObject)
	{
		#if debug
			HXP.console.update();
		#end
		//super(obj.x, obj.y);
		super(200,200);
		
		spKamikaze = new Spritemap("gfx/kamikaze.png", 110, 48);
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
		//start = new deep.math.Point(200, 200);
		//control = new deep.math.Point(700, 900);
		//endPoint = new deep.math.Point(1200, 200);
		//start = new Point(this.x, this.y);
		nullPoint = new deep.math.Point(-1000, -1000);
		
		LoadBezier();
		bezierPoints = new Array<flash.geom.Point>();
	}
	
	
	/**
		* - Inicializo el array de curvas de bezier, agregando una
		* curva y el punto de inicio de la misma
		*/	
	public function LoadBezier():Void
 {
		beziersKamikaze = new Array<Bezier>();
		AddBezierKamikaze(this.x, this.y);
		
		//beziersKamikaze.push(new Bezier(nullPoint,nullPoint,nullPoint,false));
		//countCurves++;
		
		//start = new deep.math.Point(this.x, this.y);
		//beziersKamikaze[countCurves - 1].start = new deep.math.Point(this.x, this.y);//start;
		//myBezier = new Bezier(startPoint, controlPoint, endPoint, true);
		
		//LoadBezierPoints();
	}
	
	public function AddBezierKamikaze(x:Float = 0, y:Float = 0):Void
	{
		beziersKamikaze.push(new Bezier((new deep.math.Point(x, y)), nullPoint, nullPoint, false));
		countCurves++;		
	}
	
	public function AddPointBezierKamikaze():Void
	{

		if (beziersKamikaze[countCurves - 1].control == nullPoint)
		{
			beziersKamikaze[countCurves - 1].control = new deep.math.Point(Input.mouseX, Input.mouseY);
			canRender = true;
		}
		else
		if (beziersKamikaze[countCurves - 1].end == nullPoint)
		{
			beziersKamikaze[countCurves - 1].end = new deep.math.Point(Input.mouseX, Input.mouseY);
			LoadBezierPoints();
			/**
			 * - Si despues de agregar el punto end de la curva quedan mas
				*  curvas por agregar, entonces se agrega la nueva curva con
				*  punto start donde termina la curva actual en el punto end
				* */
			if (countCurves < numCurves)
				AddBezierKamikaze(beziersKamikaze[countCurves - 1].end.x, beziersKamikaze[countCurves - 1].end.y);
			else
				banzai = true;// si no quedan mas curvas por agregar se lanza el avion
		}
		
		//trace("beziersKamikaze[countCurves - 1].start = " + beziersKamikaze[countCurves - 1].start);
		//trace("beziersKamikaze[countCurves - 1].control = " + beziersKamikaze[countCurves - 1].control);			
		//trace("beziersKamikaze[countCurves - 1].end = " + beziersKamikaze[countCurves - 1].end);		
	}
	
	override public function update():Void
	{
		super.update();
		
		#if debug
			if (Input.check(Key.R))
			 HXP.scene = new scenes.GameScene();
		#end
		
		if (Input.mousePressed && countCurves <= numCurves && !banzai)
		{
			AddPointBezierKamikaze();
		}
		else
		if (banzai)
		{
			MoveOnBezier();
		}

		//trace("Math.ffloor(testValue) = " + Math.ffloor(testValue));
		//trace("Math.floor(testValue) = " + Math.floor(testValue));
		//trace("Math.ceil(testValue) = " + Math.ceil(testValue));
		//trace("Math.fceil(testValue) = " + Math.fceil(testValue));
		//trace("Math.round(testValue) = " + Math.round(testValue));
		//trace("Math.fround(testValue) = " + Math.fround(testValue));
		
		// moviendo el avion sobre la trayectoria de las curvas
		//if (this._point.x != myBezier.end.x && this._point.y != myBezier.end.y)
		//{
		
			///////////////////MoveOnBezier();

		//}
	}

	
	public function LoadBezierPoints():Void
	{
		var t = 0.05;
		while (t <= duration - 0.05)
		{
			var p = beziersKamikaze[countCurves - 1].getPoint(t);
			bezierPoints.push(new flash.geom.Point(p.x,p.y));
			
			t += 0.05;
		}
		/*
		bezierPoints = new Array<flash.geom.Point>();
		var t = 0.0;
		while (t <= duration)
		{
			var p = myBezier.getPoint(t);
			bezierPoints.push(new flash.geom.Point(p.x,p.y));
			
			t += 0.05;
		}
		*/
	}
	
	public function MoveOnBezier():Void
	{
		timeBezier += timeStep;
		if (timeBezier < duration * countCurves)
		{
			var indexBezier = Math.floor(timeBezier);
			var timeAuxBezier = timeBezier - ( (timeBezier > 1) ? Math.ffloor(timeBezier) : 0 );
			//trace("timeBezier = "+timeBezier+"   timeAuxBezier = "+timeAuxBezier);
			var p = beziersKamikaze[indexBezier].getPoint(timeAuxBezier);// obtengo el punto de la curva de bezier			
			moveTo(p.x, p.y);// muevo la entidad hacia el punto obtenido
			
			// se obtiene el angulo de la tangente en el tiempo t de la curva
			var r = beziersKamikaze[indexBezier].getTangentAngle(timeAuxBezier);
			spKamikaze.angle = - (r * 180.0/Math.PI);
		}
		/*
		timeBezier += timeStep;
		if (timeBezier < duration)
		{
			var p = myBezier.getPoint(timeBezier);// obtengo el punto de la curva de bezier			
			moveTo(p.x, p.y);// muevo la entidad hacia el punto obtenido
			
			// se obtiene el angulo de la tangente en el tiempo t de la curva
			var r = myBezier.getTangentAngle(timeBezier);
			spKamikaze.angle = - (r * 180.0/Math.PI);
		}
		*/
	}
	
	public function ViewData():Void
	{
		//trace("spKamikaze.x = "+this.x+"  spKamikaze.y = "+this.y);
	}
	
	override public function render():Void
	{
		super.render();
		
		//RenderSolo();
		RenderCurves();
	}
	
	public function RenderCurves():Void
	{
		// dibujando los puntos start,control,end de cada curva
		for (bk in 0...beziersKamikaze.length)
		{
			if (beziersKamikaze[bk].start != nullPoint)
				redPoint.render(HXP.buffer, new flash.geom.Point( beziersKamikaze[bk].start.x, beziersKamikaze[bk].start.y), HXP.camera);
			
			if (beziersKamikaze[bk].control != nullPoint)
				greenPoint.render(HXP.buffer, new flash.geom.Point( beziersKamikaze[bk].control.x, beziersKamikaze[bk].control.y), HXP.camera);
			
			if (beziersKamikaze[bk].end != nullPoint)
				bluePoint.render(HXP.buffer, new flash.geom.Point( beziersKamikaze[bk].end.x, beziersKamikaze[bk].end.y), HXP.camera);			
		}
		
		// dibujo el recorrido de la curva de bezier
		for (p in 0...bezierPoints.length)
		{
			graphicPoint.render(HXP.buffer, new flash.geom.Point(bezierPoints[p].x,bezierPoints[p].y), HXP.camera);
		}
	}
	
	public function RenderSolo():Void
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
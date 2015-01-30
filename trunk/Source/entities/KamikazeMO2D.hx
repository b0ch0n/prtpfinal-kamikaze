package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.math.Vector;
import flash.geom.Point;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.HXP;

import nape.phys.Body;
import com.haxepunk.nape.NapeEntity;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class KamikazeMO2D extends Entity
{
	
	private var bezierMO2D : CurveBezierMO2D = null;
	private var banzai:Bool = false;
	private var bezierPointsLoaded:Bool = false;
	private var spKamikaze : Spritemap;
	private var pointsForCurve : Int = 3;
	private var countPoints : Int = 0;
	private var bezierPoints : Array<flash.geom.Point>;
	private var bezierPointsAngles:Array<Float>;
	private var duration:Float = 1.0;
	private var timeBezier:Float = 0.0;
	private var timeStep:Float = 0.005;// 0.05;
	private var indexBezierPoint:Int = 0;
	
	
	public function new(obj : TmxObject)
	{
		super(obj.x, obj.y, graphic, mask);
		set_name("KamikazeMO2D");
		
		spKamikaze = new Spritemap("gfx/kamikaze.png", 110, 48);
		spKamikaze.add("flying", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 5);
		spKamikaze.play("flying");		
		spKamikaze.centerOrigin();
		graphic = spKamikaze;

		bezierMO2D = new CurveBezierMO2D(this.x, this.y);
		countPoints++;
		bezierPoints = new Array<flash.geom.Point>();
		bezierPointsAngles = new Array < Float >();
		
		trace("KamikazeMO2D IDEA: Tener distintos tipos de aviones"
		+", ej: uno con ametralladora, otro tira bombas, otro misiles");

	}
	
	
	override public function update():Void
	{
		super.update();

		#if debug
			if (Input.pressed(Key.R))
			{
				HXP.scene = new scenes.GameScene();
			}
		#end
		
		if (Input.mousePressed && countPoints <= pointsForCurve && !banzai)
		{
			bezierMO2D.AddControlPoint(new flash.geom.Point(Input.mouseX, Input.mouseY));
			bezierMO2D.LoadBezierPoints();
			countPoints++;
			
			if (countPoints == pointsForCurve)
			{
				banzai = true;
			}
		}
		else
		if (banzai)
		{
			MoveOnBezier();
		}
	}
	
	override public function render():Void
	{
		super.render();
		
		bezierMO2D.render();
	}

	public function MoveOnBezier():Void
	{
		if (bezierPointsLoaded)
		{
			if (indexBezierPoint < bezierPoints.length)
			{
				moveTo(bezierPoints[indexBezierPoint].x, bezierPoints[indexBezierPoint].y);
				spKamikaze.angle = bezierPointsAngles[indexBezierPoint];
				indexBezierPoint++;
			}
		}
		else
		{
			LoadBezierPoints();
			LoadBezierPointsAngles();
			bezierPointsLoaded = true;
		}
		

	}
	
	public function LoadBezierPoints():Void
	{
		// borra todos los puntos guardados
		bezierPoints.splice(0, bezierPoints.length);
		
		var t = 0.0;
		while (t <= duration)
		{
			var p:Vector = bezierMO2D.Calculate(t);
			bezierPoints.push(new flash.geom.Point(  p.x,p.y));
			
			t += timeStep;
		}
	}
	
	public function LoadBezierPointsAngles():Void
	{
		for (bp in 0...(bezierPoints.length-1))
		{
			var dx:Float = bezierPoints[bp + 1].x - bezierPoints[bp].x;
			var dy:Float = bezierPoints[bp + 1].y - bezierPoints[bp].y;
			bezierPointsAngles.push( -(Math.atan2( dy, dx ) * 180.0/Math.PI) );
		}
		// correccion del angulo para el ultimo punto de la curva
		bezierPointsAngles[bezierPointsAngles.length] = bezierPointsAngles[bezierPointsAngles.length - 1];
	}
	
}
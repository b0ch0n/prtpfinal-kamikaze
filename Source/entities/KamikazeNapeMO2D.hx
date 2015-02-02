package entities;

import flash.geom.Point;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.util.FlxColor;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.util.BitmapDebug;

import nape.constraint.Constraint;
import nape.constraint.WeldJoint;
import nape.dynamics.Arbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Circle;
import nape.shape.Shape;
import nape.space.Space;

import nape.phys.BodyType;
import nape.constraint.PivotJoint;

import nape.util.Debug;
import flixel.FlxG;
import flixel.util.FlxAngle;

import flixel.util.FlxSpriteUtil.DrawStyle;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;
//import flixel.plugin.MouseEventManager;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class KamikazeNapeMO2D extends FlxNapeSprite
{
	
	private var bezierMO2D : CurveBezierMO2D = null;
	private var banzai:Bool = false;
	private var bezierPointsLoaded:Bool = false;
	private var spKamikaze : FlxSprite;
	private var pointsForCurve : Int = 5;
	private var countPoints : Int = 0;
	private var bezierPoints : Array<flash.geom.Point>;
	private var bezierPointsAngles:Array<Float>;
	private var duration:Float = 1.0;
	private var timeBezier:Float = 0.0;
	private var timeStep:Float = 0.005;// 0.05;
	private var indexBezierPoint:Int = 0;
	
	private var bodyAux:Body;
	private var debugNape:Debug;
	private var space:Space;
	
	private var deltaX:Float = 0.0;
	private var deltaY:Float = 0.0;	

	/**
		* @param	obj : objeto leído en el nivel tmx del formato tiled 
	 * @param	space : Space world del Engine Nape en el cual se debe agregar el body del actual objeto
		* con las propiedades physics para interactuar.
	 */
	public function new(obj : TiledObject, spaceNape : Space = null)
	{
		
		super(obj.x, obj.y);

		space = spaceNape;
		
		SetBodiesNape(obj, spaceNape);
		this.loadGraphic("gfx/kamikaze.png", true, 110, 48, false);
		this.animation.add("flying", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 30, true);
		this.animation.play("flying", true);
		this.centerOrigin();
		

		bezierMO2D = new CurveBezierMO2D(obj.x , obj.y);
		
		countPoints++;
		bezierPoints = new Array<flash.geom.Point>();
		bezierPointsAngles = new Array < Float >();
		
		//debugNape = new BitmapDebug(Std.int(FlxG.stage.width), Std.int(FlxG.stage.height), FlxG.stage.color);
		
		//MouseEventManager.setMouseDownCallback(this, OnMouseDown(Void->Void), Void);
		
	}

	private function SetBodiesNape(obj:TiledObject, spaceNape:Space):Void
	{
		// body heredado de NapeEntity
		body = new Body(BodyType.DYNAMIC);
		body.position.setxy(obj.x, obj.y);
		//body.shapes.add(new Polygon(Polygon.box(50, 30))); // new Circle(20));
		var localVerts:Array<Vec2> = new Array<Vec2>();
		//localVerts.push(new Vec2(  10,  5));
		//
		//localVerts.push(new Vec2(   5, 10));
		//localVerts.push(new Vec2(  -5, 10));
		//
		//localVerts.push(new Vec2( -60,  5));
		//localVerts.push(new Vec2( -60, -5));
		//
		//localVerts.push(new Vec2( -5, -10));
		//localVerts.push(new Vec2(  5, -10));
		//
		//localVerts.push(new Vec2( 10, -5));		
		//localVerts.push(new Vec2( 10,  5));
		
		
		localVerts.push(new Vec2( 15,  5));
		localVerts.push(new Vec2( 10, 10));
		localVerts.push(new Vec2( -5, 10));
		localVerts.push(new Vec2( -10,  5));
		
		//localVerts.push(new Vec2(-45,  0));
		//localVerts.push(new Vec2(-45, -5));
		
		localVerts.push(new Vec2(-10, -8));
		localVerts.push(new Vec2(-5, -10));
		localVerts.push(new Vec2( 10,-10));
		localVerts.push(new Vec2( 15, -5));
		localVerts.push(new Vec2( 15,  5));
		
		
		
		body.shapes.add(new Polygon(localVerts));
		localVerts.splice(0, localVerts.length);
		//body.align();
		//body.localCOM.set(new Vec2(30, 15));
		
		/*
	Construct a new Material object.
	parameters
	elasticity :: 0 : The coeffecient of elasticity for material.
	dynamicFriction :: 1 : The coeffecient of dynamic friction for material.
	staticFriction :: 2 : The coeffecient of static friction for material.
	density :: 1 : The density of the shape using this material in units of g/pixel/pixel.
	rollingFriction :: 0.001 : The coeffecient of rolling friction for material used in circle friction computations.
	returns
	The constructed Material object.
		*/
		// Material(elasticity=0, dynamicFriction=1, staticFriction=2, density=1, rollingFriction=0.001));//default values
		//body.setShapeMaterials(new Material(0, 1, 2, 1, 0.001));//default values
		body.setShapeMaterials(new Material(1, 0.2, 0.5, 0.5, 0.001));
		body.allowMovement = false;
		body.allowRotation = false;
		body.mass = 0.2;
		body.space = spaceNape;
		
		// body agregado en variable auxiliar
		bodyAux = new Body(BodyType.DYNAMIC);
		bodyAux.position.setxy(obj.x - 10, obj.y);
		//bodyAux.shapes.add(new Polygon(Polygon.box(20, 20)));//new Circle(10));
		
		localVerts.push(new Vec2( 0,  5));
		
		localVerts.push(new Vec2( -35,  0));
		localVerts.push(new Vec2( -35, -5));
		
		localVerts.push(new Vec2( 0, -8));
		localVerts.push(new Vec2( 0,  5));
		
		bodyAux.shapes.add(new Polygon(localVerts));
		// Material(elasticity=0, dynamicFriction=1, staticFriction=2, density=1, rollingFriction=0.001));//default values
		bodyAux.setShapeMaterials(new Material(1, 0.2, 0.5, 0.5, 0.001));
		bodyAux.allowMovement = true;// false;
		bodyAux.mass = 0.02;
		//bodyAux.space = spaceNape;
		
		// uniendo los bodies
		WeldJointBodies(obj);
	}
	
	public function WeldJointBodies(obj:TiledObject=null):Void
	{
		// Vec2.get((body.position.x + bodyAux.position.x) / 2, (body.position.y + bodyAux.position.y) / 2);
		var anchor = new Vec2();// 50 , 50);
		var weldJoint = new WeldJoint(
		body,
		bodyAux,
		body.worldPointToLocal(anchor, true),
		bodyAux.worldPointToLocal(anchor, true)
		);
		anchor.dispose();
		weldJoint.stiff = true;// o false;// union rigida o elastica
		weldJoint.ignore = true;// ignora colisiones con los bodies unidos
		weldJoint.debugDraw = true;
		weldJoint.space = space;
	}

	override public function update():Void
	{
		super.update();
		//x = body.position.x - 15 * Math.cos(angle * FlxAngle.TO_RAD);
		//y = body.position.y - 15 * Math.sin(angle * FlxAngle.TO_RAD);
		
		if (FlxG.mouse.justReleased && countPoints <= pointsForCurve && !banzai)
		{
			bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.x, FlxG.mouse.y));
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
	
	//public function OnMouseDown():Void
	//{
		//if (FlxG.mouse.pressed && countPoints <= pointsForCurve && !banzai)
		//{
			//bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.x, FlxG.mouse.y));
			//bezierMO2D.LoadBezierPoints();
			//countPoints++;
			//
			//if (countPoints == pointsForCurve)
			//{
				//banzai = true;
			//}
		//}
		//else
		//if (banzai)
		//{
			//MoveOnBezier();
		//}
	//}
	
	override public function draw():Void
	{
		super.draw();
		
		bezierMO2D.draw();
		
		//FlxSpriteUtil.drawRect(this, FlxG.stage.x, FlxG.stage.y, FlxG.stage.width, FlxG.stage.height, FlxColor.CYAN, LineStyle, FillStyle, DrawStyle);
	}

	public function MoveOnBezier():Void
	{
		if (bezierPointsLoaded)
		{
			if (indexBezierPoint < bezierPoints.length)
			{
				//moveTo(bezierPoints[indexBezierPoint].x, bezierPoints[indexBezierPoint].y);
				body.position.setxy(
				bezierPoints[indexBezierPoint].x,
				bezierPoints[indexBezierPoint].y);
				//spKamikaze.angle = bezierPointsAngles[indexBezierPoint];
				body.rotation = bezierPointsAngles[indexBezierPoint];
				indexBezierPoint++;
				
				//trace("angle = " + angle);// * HXP.RAD);
				if (indexBezierPoint >= bezierPoints.length)
				{
					LaunchKamikaze();
				}
			}
			//else
			//{
				//
			//}
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
		//var timeAux = HXP.elapsed;
		while (t <= duration)
		{
			var p:flash.geom.Point = bezierMO2D.Calculate(t);
			bezierPoints.push(new flash.geom.Point(  p.x,p.y));
			
			t += timeStep;
			//t += timeAux;
		}
	}
	
	public function LoadBezierPointsAngles():Void
	{
		for (bp in 0...(bezierPoints.length-1))
		{
			var dx:Float = bezierPoints[bp + 1].x - bezierPoints[bp].x;
			var dy:Float = bezierPoints[bp + 1].y - bezierPoints[bp].y;
			//bezierPointsAngles.push( -(Math.atan2( dy, dx ) * 180.0 / Math.PI) );
			bezierPointsAngles.push( (Math.atan2( dy, dx )));// * 180.0 / Math.PI) );
						
		}
		// correccion del angulo para el ultimo punto de la curva
		bezierPointsAngles[bezierPointsAngles.length] = bezierPointsAngles[bezierPointsAngles.length - 1];
		deltaX = bezierPoints[bezierPoints.length - 1].x - bezierPoints[bezierPoints.length-2].x;
		deltaY = bezierPoints[bezierPoints.length - 1].y - bezierPoints[bezierPoints.length-2].y;		
	}
	
	public function LaunchKamikaze():Void
	{
		//trace("Baaannnzaaaiii!!!");
		body.allowMovement = true;
		body.allowRotation = true;
		bodyAux.allowMovement = true;
		var power = 50;
		var power2 = 10;
		//var impulse:Vec2 = new Vec2( power * Math.cos( angle * HXP.RAD), power * Math.sin( angle * HXP.RAD));
		var impulse:Vec2 = new Vec2(deltaX * power2, deltaY * power2);
		
		trace("angle = " + angle + "  impulse = " + impulse);
		//body.force = impulse;
		
		body.applyImpulse(impulse, null, true);
		//bodyAux.applyImpulse(impulse, null, true);
	}
	
}
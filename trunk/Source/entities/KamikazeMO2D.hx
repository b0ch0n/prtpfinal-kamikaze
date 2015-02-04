package entities;

import flixel.addons.editors.tiled.TiledObject;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxAngle;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.Debug;
import flash.geom.Point;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class KamikazeMO2D extends FlxSprite
{
	
	private var bezierMO2D : CurveBezierMO2D = null;
	private var banzai:Bool = false;
	private var kamikazeLaunched:Bool = false;
	private var bezierPointsLoaded:Bool = false;
	private var drawing:Bool = true;
	private var spKamikaze : FlxSprite;
	private var pointsForCurve : Int = 3;
	private var countPoints : Int = 0;
	private var bezierPoints : Array<flash.geom.Point>;
	private var bezierPointsAngles:Array<Float>;
	private var duration:Float = 1.0;
	private var timeBezier:Float = 0.0;
	private var timeStep:Float = 0.005;// 0.05;
	private var indexBezierPoint:Int = 0;
	
	private var body:Body;
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
		//cargo la imagen de animacion
		this.loadGraphic("gfx/kamikaze-1760-80x38.png", true, 80, 38);
		//this.loadRotatedGraphic("gfx/kamikaze-1760-80x38.png", 360, 0, false, true);
		this.animation.add("flying", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 30, true);
		this.animation.play("flying", true);
		//this.bakedRotationAngle = 1.0;
		
		//this.angle = 45.0;
		//FlxAngle.rotatePoint(width, _halfHeight, x, y, 45.0);
		this.centerOrigin();
		SetBodiesNape(obj, spaceNape);
		
/*		
		scale.set( 0.25, 0.25);
		//body.shapes.add(new Circle(15));
		body.mass = 100;
		
		body.allowMovement = false;
		body.space = spaceNape;
		//body.allowMovement = true;
		//
		//var testBody = new Body(BodyType.DYNAMIC, new Vec2(obj.x+150, obj.y));
		//testBody.shapes.add(new Circle(50));
		//testBody.allowMovement = true;
		//testBody.mass = 100;
		//testBody.space = spaceNape;
		
		space = spaceNape;
		
		//SetBodiesNape(obj, spaceNape);
		physicsEnabled = true;
*/
		

		bezierMO2D = new CurveBezierMO2D(obj.x , obj.y);
		
		countPoints++;
		bezierPoints = new Array<flash.geom.Point>();
		bezierPointsAngles = new Array < Float >();
		
		//FlxG.camera.setBounds(0, 0, 640, 480, true);// FlxG.width, FlxG.height, true);
		FlxG.camera.follow(this,FlxCamera.STYLE_PLATFORMER);
	}

	private function SetBodiesNape(obj:TiledObject, spaceNape:Space):Void
	{
		// body heredado de NapeEntity
		body = new Body(BodyType.DYNAMIC);
		body.position.setxy(obj.x, obj.y);
		body.debugDraw = true;
		body.mass = 1;
		body.allowMovement = false;
		body.allowRotation = true;
		body.shapes.add(new Polygon(Polygon.box(40, 30))); // new Circle(20));
		body.space = spaceNape;
		/*
		var localVerts:Array<Vec2> = new Array<Vec2>();

		localVerts.push(new Vec2(40,5));
		localVerts.push(new Vec2(23,-12));
		localVerts.push(new Vec2(7,-12));
		localVerts.push(new Vec2( -5, -3));
		
		//localVerts.push(new Vec2(-25,-3));
		//localVerts.push(new Vec2( -28, -12));
		//localVerts.push(new Vec2( -35, -12));
		
		//localVerts.push(new Vec2(-40,5));
		localVerts.push(new Vec2(-5,17));
		//localVerts.push(new Vec2(-5,-3));
		
		//localVerts.push(new Vec2(-5,17));
		localVerts.push(new Vec2(6,19));
		localVerts.push(new Vec2(15,19));
		localVerts.push(new Vec2(32,17));
		localVerts.push(new Vec2(40,5));
		*/
		//body.shapes.add(new Polygon(localVerts));
		//body.shapes.add(new Circle(14));// Polygon(Polygon.rect(0, 7, 20, 14, true)));
		//localVerts.splice(0, localVerts.length);
/*
		// Material(elasticity=0, dynamicFriction=1, staticFriction=2, density=1, rollingFriction=0.001));//default values
		body.setShapeMaterials(new Material(0, 1, 2, 1, 0.001));//default values
		//body.setShapeMaterials(new Material(1, 0.2, 0.5, 0.5, 0.001));
		body.allowMovement = false;
		body.allowRotation = true;// false;
		body.mass = 10.2;
		body.space = spaceNape;
		//body.align();
		
		// body agregado en variable auxiliar
		bodyAux = new Body(BodyType.DYNAMIC);
		bodyAux.position.setxy(obj.x - 10, obj.y);
		//bodyAux.shapes.add(new Polygon(Polygon.box(20, 20)));//new Circle(10));

		localVerts.push(new Vec2(-5,-3));
		localVerts.push(new Vec2(-40,-2));
		localVerts.push(new Vec2(-40,5));
		localVerts.push(new Vec2(-5,17));
		localVerts.push(new Vec2(-5,-3));
		
		bodyAux.shapes.add(new Polygon(localVerts));
		// Material(elasticity=0, dynamicFriction=1, staticFriction=2, density=1, rollingFriction=0.001));//default values
		bodyAux.setShapeMaterials(new Material(1, 0.2, 0.5, 0.5, 0.001));
		bodyAux.allowMovement = true;// false;
		bodyAux.mass = 0.02;
		*/
		//bodyAux.space = spaceNape;
		
		// uniendo los bodies
		//WeldJointBodies(obj);
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
		weldJoint.stiff = false;// true o false;// union rigida o elastica
		weldJoint.ignore = true;// ignora colisiones con los bodies unidos
		weldJoint.debugDraw = true;
		weldJoint.space = space;
	}

	override public function update():Void
	{
		super.update();
		x = body.position.x - this._halfWidth;// * Math.cos(angle * FlxAngle.TO_RAD);
		y = body.position.y - this._halfHeight;// * Math.sin(angle * FlxAngle.TO_RAD);
		angle = body.rotation * FlxAngle.TO_DEG;

		if (FlxG.mouse.justReleased && countPoints <= pointsForCurve && !banzai)
		{
			bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.x, FlxG.mouse.y));
			bezierMO2D.LoadBezierPoints();
			countPoints++;
			
			if (countPoints == pointsForCurve && !banzai)
			{
				banzai = true;
			}
		}
		else
		if (banzai)
		{
			if (!kamikazeLaunched)
				MoveOnBezier();
		}
		
		//trace("body.kinematicVel = " + body.kinematicVel + "  body.inertia = " + body.inertia + "  body.gravMass = " + body.gravMass);
		//trace("body.localCOM = " + body.localCOM + "  body.mass = " + body.mass + "  body.space = " + body.space);
		//trace("body.velocity = " + body.velocity + "  body.type = " + body.type + "  body.constraintVelocity = " + body.constraintVelocity);
		//trace("body.space.elapsedTime = " + body.space.elapsedTime + "  body.space.gravity = " + body.space.gravity);
		//trace("");

		
		#if debug
			if (FlxG.keys.justReleased.D)
			{
				drawing = !drawing;
			}
		#end
		
		FlxG.camera.update();
	}
	
	override public function draw():Void
	{
		if (drawing)
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
				
				body.position.setxy(	bezierPoints[indexBezierPoint].x,	bezierPoints[indexBezierPoint].y);
				
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
		/*
		var t = 0.0;
		//var timeAux = HXP.elapsed;
		while (t <= duration)
		{
			var p:flash.geom.Point = bezierMO2D.Calculate(t);
			bezierPoints.push(new flash.geom.Point(  p.x,p.y));
			
			t += timeStep;
			//t += timeAux;
		}
		*/
		
		var LOD = countPoints * 4;
		var dt = 1.0 / (LOD - 1.0);
		var k = 0;
		while (k < LOD)
		{
			var t = dt * k;
			if (t <= 1.0)
				t -= 0.00001;
			
			bezierPoints.push(bezierMO2D.Calculate(t));
			
			k++;
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
		//bodyAux.allowMovement = true;
		var power = 50;
		var power2 = 10;
		//var impulse:Vec2 = new Vec2( power * Math.cos( angle * HXP.RAD), power * Math.sin( angle * HXP.RAD));
		var impulse:Vec2 = new Vec2(deltaX * power, deltaY * power);
		//var impulse:Vec2 = new Vec2(deltaX * power2, deltaY * power2);
		
		//trace("angle = " + angle + "  impulse = " + impulse);
		//trace("indexBezierPoint = " + indexBezierPoint + "   bezierPoints.length = " + bezierPoints.length);
		//body.force = impulse;
		
		//body.applyImpulse(impulse, new Vec2(this.x, this.y), false);
		//body.velocity.setxy(123, 123);// impulse);
		body.applyImpulse(impulse, null, true);
		kamikazeLaunched = true;
		//bodyAux.applyImpulse(impulse, null, true);
		
		//FlxG.camera.shake(0.05, 0.5);
	}
	
}
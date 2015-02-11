package entities;

import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxAngle;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.Debug;
import flash.geom.Point;

import flixel.system.FlxSound;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class KamikazeMO2D extends FlxSprite
{

	private var snd_banzai:FlxSound;
	
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
		space = spaceNape;
		SetBodiesNape(obj);

		bezierMO2D = new CurveBezierMO2D(obj.x , obj.y);
		
		countPoints++;
		bezierPoints = new Array<flash.geom.Point>();
		bezierPointsAngles = new Array < Float >();
		
		snd_banzai = new FlxSound();
		snd_banzai.loadEmbedded(GC.SND_banzai_02);
	}

	private function SetBodiesNape(obj:TiledObject):Void
	{
		// body heredado de NapeEntity
		body = new Body(BodyType.DYNAMIC);
		body.position.setxy(obj.x, obj.y);
		body.debugDraw = true;
		body.mass = 0.75;
		body.allowMovement = false;
		body.allowRotation = false;
		body.setShapeMaterials(new Material(1, 0.2, 0.5, 0.5, 0.001));
		body.space = space;
		
		var localVerts:Array<Vec2> = new Array<Vec2>();

		// vertices de la cabina del avion
		localVerts.push(new Vec2(27, 5));
		localVerts.push(new Vec2(10, -12));
		localVerts.push(new Vec2(-6, -12));
		
		localVerts.push(new Vec2( -18, -3));
		localVerts.push(new Vec2( -18, 17));
		
		localVerts.push(new Vec2(-7, 19));		
		localVerts.push(new Vec2(2, 19));		
		localVerts.push(new Vec2(19, 17));		
		localVerts.push(new Vec2(27, 5));		
		
		body.shapes.add(new Polygon(localVerts));
		
		// body agregado en variable auxiliar
		bodyAux = new Body(BodyType.DYNAMIC);
		bodyAux.position.setxy(obj.x, obj.y);

		localVerts.splice(0, localVerts.length);// vaciando el array de vertices
		
		// vertices de la cola del avion
		localVerts.push(new Vec2( -18, -3));
		
		localVerts.push(new Vec2( -48, -12));
		localVerts.push(new Vec2( -53, 5));
		
		localVerts.push(new Vec2( -18, 17));		
		localVerts.push(new Vec2( -18, -3));
		
		bodyAux.shapes.add(new Polygon(localVerts));
		// Material(elasticity=0, dynamicFriction=1, staticFriction=2, density=1, rollingFriction=0.001));//default values
		bodyAux.setShapeMaterials(new Material(1, 0.5, 0.5, 0.5, 0.001));
		bodyAux.allowMovement = true;// false;
		bodyAux.mass = 0.2;
		bodyAux.space = space;
		
		// uniendo los bodies
		WeldJointBodies(obj);
	}
	
	public function WeldJointBodies(obj:TiledObject=null):Void
	{
		var anchor = new Vec2();
		var weldJoint = new WeldJoint(
		body,
		bodyAux,
		body.worldPointToLocal(anchor, true),
		bodyAux.worldPointToLocal(anchor, true)
		);
		anchor.dispose();
		weldJoint.stiff = true;// true o false;// union rigida o elastica
		weldJoint.ignore = true;// ignora colisiones con los bodies unidos
		weldJoint.debugDraw = true;
		weldJoint.space = space;
	}

	override public function update():Void
	{
		super.update();
		x = body.position.x - this._halfWidth;
		y = body.position.y - this._halfHeight;
		angle = body.rotation * FlxAngle.TO_DEG;

		if (FlxG.mouse.justReleased && countPoints <= pointsForCurve && !banzai)
		{
			bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.x, FlxG.mouse.y));
		 //bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.stage.mouseX, FlxG.stage.mouseY));
			//bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.screenX, FlxG.mouse.screenY));
			//bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y));
			//bezierMO2D.AddControlPoint(new flash.geom.Point(FlxG.mouse.getWorldPosition().x/FlxG.camera.zoom, FlxG.mouse.getWorldPosition().y/FlxG.camera.zoom));
			
			//var vec2 : Vec2 = FlxNapeState.space.world.worldPointToLocal(new Vec2(FlxG.mouse.x, FlxG.mouse.y));
			//bezierMO2D.AddControlPoint(new flash.geom.Point(vec2.x, vec2.y));
			
			//var vec : flash.geom.Point = new flash.geom.Point(FlxG.mouse.x, FlxG.mouse.y);
			//bezierMO2D.AddControlPoint(FlxG.stage.globalToLocal(vec));
			
			//var cp:flash.geom.Point = new flash.geom.Point(this._halfWidth, this._halfHeight);
			//bezierMO2D.AddControlPoint(cp);
			
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
			if (FlxG.keys.justReleased.H)
			{
				drawing = !drawing;
			}
		#end
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

		var LOD = countPoints * 4;//10;//
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
			bezierPointsAngles.push( (Math.atan2( dy, dx )));
						
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
		
		snd_banzai.play();
	}
	
}
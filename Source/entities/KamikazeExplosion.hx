package entities;
import flash.geom.Point;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxAngle;
import nape.callbacks.BodyCallback;
import nape.callbacks.BodyListener;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import scenes.GameNapeState;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class KamikazeExplosion extends FlxSprite
{
	private var snd_explosion:FlxSound;

	private var startPos:Point;
	private var radius:Float = 10.0;
	private var power:Float = 200.0;
	private var deltaAngle:Float = 10.0;
	private var nParticles:Int;
	
	private var bodyParticle:Body;
	private var CB_Particle_VS_All:BodyCallback;
	private var listenerExplosion:BodyListener;
	
	public function new(pos:Point)//x:Float = 100.0, y:Float = 100.0)
	{
		super(pos.x, pos.y);
		this.loadGraphic(GC.IMG_explosion_1, true , 64, 64);
		//scale.set(5.0, 5.0);
		centerOrigin();
		
		var frames:Array<Int> = [];
		for(f in 0...48)
			frames.push(f);
		
		animation.add("explosion", frames, 60, false);
		animation.play("explosion", true, 0);

		startPos = pos;
		
		var angle:Float = 0.0;
		while (angle < 360.0)
		{
			var posBP:Vec2 = new Vec2(pos.x - radius * Math.cos(FlxAngle.asRadians(angle)), pos.y - radius * Math.sin(FlxAngle.asRadians(angle)));
			//var posBP:Vec2 = new Vec2(pos.x + radius * Math.random(), pos.y + radius * Math.random());
			
			//impulso en direccion desde el origen de la explosion hasta la posicion de la actual particula
			var impulse:Vec2 = new Vec2((pos.x - posBP.x) * power, (pos.y - posBP.y) * power);
			
			//trace("pos = "+pos+"   posBP = "+posBP+"   impulse = "+impulse);
			
			//trace("posBP = "+posBP+"   impulse = "+impulse);
			bodyParticle = new Body(BodyType.DYNAMIC, posBP);
			bodyParticle.mass = 0.2;
			bodyParticle.shapes.add(new Circle(1.0));
			bodyParticle.applyImpulse(impulse);
			bodyParticle.align();
			bodyParticle.isBullet = true;
			bodyParticle.space = FlxNapeState.space;

			#if debug
				bodyParticle.debugDraw = true;
			#end
			
			angle += deltaAngle;
		}
		
				
		snd_explosion = new FlxSound();
		snd_explosion.loadEmbedded(GC.SND_explosion_1);
		snd_explosion.play();

		FlxG.state.add(this);
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
}
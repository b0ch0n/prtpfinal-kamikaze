package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Proyectil extends Entity
{
	
	private var imgProyectil:Image = null;
	private var vx:Float = 0;
	private var vy:Float = 0;

 public override function new( x:Float = 0, y:Float = 0, angle:Float = 0, v:Float = 0,	source:Dynamic = null, scale:Float = 0.5)
 {
		imgProyectil = new Image(source);
		imgProyectil.centerOrigin();
		imgProyectil.angle = angle;
		imgProyectil.scale = scale;
		
		vx = v * Math.cos(GC.GetRadian(angle));
		vy = v * Math.sin(GC.GetRadian(angle));
		setHitbox(5, 5, 5, 5);
		super(x, y, imgProyectil);
		HXP.scene.add(this);
		
		type = "proyectil";
	}
	
	override public function update():Void
	{
		super.update();
		moveBy(vx, vy);
		vy += (GC.G * HXP.elapsed) / 10;
		
		if (collide("solid", x, y) != null)
		{
			HXP.scene.remove(this);
		}
		
		//trace("type = "+type.toString());
	}
	
	
	
	
	
	
	
	
	
}
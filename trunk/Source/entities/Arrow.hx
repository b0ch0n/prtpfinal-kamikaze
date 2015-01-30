package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.math.Vector;
import flash.geom.Point;
import com.haxepunk.HXP;
import entities.*;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Arrow extends Entity
{
	private var vx:Float = 0;
	private var vy:Float = 0;
	private var vFlecha:Float = 2;
	private var _sprite:Spritemap;
	private var colliders:Array<String>;	

	override public function new(x:Float=100, y:Float=100, dir:Int=0) 
	{
		super(x, y);
		_sprite = new Spritemap(GC.IMG_flecha,30,100);
		_sprite.scale = 0.2;
		
		switch(dir)
		{
			case 0:
				vy = vFlecha;
				_sprite.angle = 180;
				setHitbox(6,6,3,-3);//down
				
			case 1:
				vx = -vFlecha;
				_sprite.angle = 90;
				setHitbox(6,6,6,3);//left
				
			case 2:
				vx = vFlecha;
				_sprite.angle = -90;
				setHitbox(6,6,0,3);//right
				
			case 3:
				vy = -vFlecha;
				_sprite.angle = 0;
				setHitbox(6,6,3,6);
		}

		_sprite.centerOrigin();
		collidable = true;

		
		type = "arrow";
		
		graphic = _sprite;
	}
	
	override public function update():Void
	{
		super.update();
		//trace("vx = "+vx+"   vy = "+vy);
		
	 if (collide("trigger_block", x, y) != null)
		{
		 //HXP.world.remove(this);
			get_scene().remove(this);
			//scene.remove(this);//this.removed();
			//trace("Borrar Arrow!!!");
		}
		moveBy(vx, vy);
		
	}
}
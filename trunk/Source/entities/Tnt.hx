package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tmx.TmxObject;
import flash.geom.Point;
import com.haxepunk.HXP;

enum StateTnt
{
	IDLE; JUMP; MOVING;
}

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Tnt extends Entity
{
	private var imgTnt:Image;
	private var v:Point;
	private var state:StateTnt;

	public function new(obj:TmxObject) 
	{
		state = JUMP;
		imgTnt = new Image(GC.IMG_tnt);
		imgTnt.scale = 0.2;
		
		super(obj.x, obj.y, imgTnt);
		
		setHitbox(32, 48);
		
		v = new Point();
		type = "tnt";
	}
	
	override public function update():Void
	{
		super.update();
		
		switch(state)
		{
			case IDLE:
				if (collide("helicopter", x + 1, y) != null)
				{
					v.x = -2;
					ChangeState(MOVING);
				}
				else
				if (collide("helicopter", x - 1, y) != null)
				{
					v.x = 2;
					ChangeState(MOVING);
				}
				
			case JUMP:
				v.y += GC.G * HXP.elapsed;
				moveBy(v.x, v.y, "solid");
				if (collide("solid", x, y + 1) != null)
				{
					ChangeState(IDLE);
					v.x = 0;
					v.y = 0;
				}
				
			case MOVING:
				moveBy(v.x, v.y, "solid");
				if (collide("solid", x, y) != null)
				{
					ChangeState(IDLE);
					v.x = 0;
					v.y = 0;
				}
				
				// si NO hay piso entonces cae
				if (collide("solid", x, y + 1) == null)
				{
					ChangeState(JUMP);
				}
				
		}
		
		//trace("state.getName() = " + state.getName() + " v.x = " + v.x + " v.y = " + v.y);
		
		if (collide("proyectil", x, y) != null)
		{
			HXP.scene.add(new Explosion(x, y));
			HXP.scene.remove(this);
		}
	}
	
	public function ChangeState(newState:StateTnt):Void
	{
		state = newState;
	}
	
}
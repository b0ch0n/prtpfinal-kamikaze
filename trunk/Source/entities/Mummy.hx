package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tmx.TmxObject;
import flash.geom.Point;
import com.haxepunk.HXP;
import com.haxepunk.masks.Pixelmask;
import com.haxepunk.tweens.misc.VarTween;

enum StateMummy
{
	INIT; GET_UP; WALK; ATTACK; DEATH;
}

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Mummy extends Entity
{
	private var spMummy:Spritemap;
	private var target:Tank;
	private var state:StateMummy;
	private var v:Point;
	private var tweenDeltaAABB:VarTween;
	private var deltaAABB:Int;

	public function new(obj:TmxObject = null, x:Float = 0, y:Float = 0)
	{
		state = INIT;
		spMummy = new Spritemap(GC.IMG_momia, 150, 100);
		spMummy.add(INIT.getName(), [49], 0, false);
		spMummy.add(GET_UP.getName(), [49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65], 8, false);
		spMummy.add(WALK.getName(), [31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48], 6, true);
		spMummy.add(ATTACK.getName(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14], 8, false);
		spMummy.add(DEATH.getName(), [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30], 8, false);
				
		spMummy.play(state.getName());
		
		if (obj == null)
			super(x, y, spMummy);
		else
			super(obj.x, obj.y, spMummy);

		spMummy.centerOrigin();
		setHitbox(18, 45, 9, -5);
		type = "mummy";
		
		v = new Point();
		
		deltaAABB = 52;
		tweenDeltaAABB = new VarTween();
		addTween(tweenDeltaAABB);
	}
	
	override public function update():Void
	{
		super.update();
		
		if (target == null)
			target = cast(scene.getInstance("Tank"), Tank);
		
		spMummy.flipped = (target.x > x);
			
		switch(state)
		{
			case INIT:
				v.y += GC.G * HXP.elapsed;
				moveBy(v.x, v.y, "solid");
				if (collide("solid", x, y+1) != null)
					{
						v.y = 0;
						ChangeState(GET_UP);
					}
					
			case GET_UP:
				if (spMummy.complete)
					ChangeState(WALK);
					
			case WALK:
				v.x = (target.x > x) ? 0.5 : -0.5;
				moveBy(v.x, 0, "solid");
				if (distanceToPoint(target.x, target.y) < 50)
					ChangeState(ATTACK);
					
			case ATTACK:
				if (spMummy.complete)
					{
						(spMummy.flipped) ?	setHitbox(18 + deltaAABB, 45, 9, -5) : setHitbox(18 + deltaAABB, 45, 9 + deltaAABB, -5);
						
						if (collide("tank", x, y) != null)
							target.Damage(5);
						ChangeState(DEATH);
					}
				
				//tweenDeltaAABB.tween(this, "deltaAABB", 72, 1);
				
				
					
			case DEATH:
				if (spMummy.complete)
					scene.remove(this);
			//default:trace();	
		}
		
		if (collide("explosion", x, y) != null)
		{
			ChangeState(DEATH);
		}
		

	}
	
	
	public function ChangeState(newState:StateMummy):Void
	{
		state = newState;
		spMummy.play(state.getName(), true);		
	}
	
}
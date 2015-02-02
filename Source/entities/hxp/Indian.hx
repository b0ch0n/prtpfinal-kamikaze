package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import scenes.*;

enum State
{
	IDLE;
	RUN;
	JUMP;
	FALL;
	DYING;
}

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Indian extends Entity
{
	private var vx:Float = 0.0;
	private var vy:Float = 0.0;
	private var direction:Int = 1;
	private var numJumps:Int = 0;
	
	private var _sprite:Spritemap;
	private var _state:State;
	private var colliders:Array<String>;
	private var anim:Array<String>;
	
	
	public function new(obj:TmxObject) 
	{
		super(obj.x, obj.y);
		_state = State.IDLE;
		type = "indian";
		collidable = true;
		
		anim = ["idle","run","jump","fall","dying"];
		// type's de entity con los que voy a detectar colisiones
		//colliders = ["solid"];//"exit","trigger_block","arrow",
		colliders = ["solid"];
		
		_sprite = new Spritemap(GC.IMG_indian, 64, 64);
		_sprite.add(anim[IDLE.getIndex()], [9, 10, 11], 4);
		_sprite.add(anim[RUN.getIndex()], [23, 24, 25, 26, 21, 22], 8);
		_sprite.add(anim[JUMP.getIndex()], [12, 13, 14, 15, 16, 17], 8, false);
		_sprite.add(anim[FALL.getIndex()], [18, 19, 18, 20], 12, false);
		_sprite.add(anim[DYING.getIndex()], [0, 1, 2, 3, 4, 5], 6, false);
		
		_sprite.play(anim[_state.getIndex()]);
		_sprite.centerOrigin();
		_sprite.scale = 0.75;
		_sprite.flipped = true;
		setHitbox(14, 30, 7, 5);
		
		//defino los movimientos basicos del player
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);	
		
		graphic = _sprite;
	}
	
	override public function update():Void
	{
		super.update();
		
		switch(_state)
		{
			case IDLE:
				vx = 0;
				vy = 0;
				//si se presiona hacia arriba entonces salta
				if (Input.check("up"))
				{
					//vy = -5;
					//ChangeState(JUMP);
					Saltar();
				}
				
				//si se presiona hacia la izquierda corremos
				if (Input.check("left"))
				{
					_sprite.flipped = false;
					vx = -1.5;
					ChangeState(RUN);
				}
				
				// si se presiona hacia la derecha corremos
				if (Input.check("right"))
				{
					_sprite.flipped = true;
					vx = 1.5;
					ChangeState(RUN);
				}
				
				//si no hay piso entonces caemos saltando
				if (collide("solid", x, y + 1) == null)
					ChangeState(JUMP);
				
			case RUN:
				//si mira hacia la izquierda y no presiono nada paso al estado quieto
				if (!_sprite.flipped && !Input.check("left"))
				{
					vx = 0;
					ChangeState(IDLE);
				}
				
				//si no presiono nada paso al estado quieto
				if (_sprite.flipped && !Input.check("right"))
				{
					vx = 0;
					ChangeState(IDLE);
				}
				
				//si presiono saltar paso a saltar corriendo
				if (Input.check("up"))
				{
					Saltar();
					//vy = -5;
					//ChangeState(JUMP);
				}
				
				//si no hay piso entonces cae
				if (collide("solid", x, y + 1) == null)
				{
					//trace("NO HAY PISO!!!");
					ChangeState(JUMP);
				}
				
			case JUMP:
				vy += GC.G * HXP.elapsed;
				//si choco contra el piso hacia abajo cambio al estado de caida al piso
				if (collide("solid", x, y + 1) != null)
				{
					//trace("COLLISION!!!");
					vy = 0;
					ChangeState(FALL);
				}
				
				if (vx<=0 && Input.check("left"))
				{
					_sprite.flipped = false;
					vx = -1.5;
				}
				
				if (vx>=0 && Input.check("right"))
				{
					_sprite.flipped = true;
					vx = 1.5;
				}
				//si choco contra alguna pared cambio al estado quieto
				if ((vx>0 && collide("solid", x + 1, y) != null) || (vx<0 && collide("solid", x - 1, y) != null))
				{
					vx = 0;
					//ChangeState(IDLE);
				}
				
				//si se presiona hacia arriba entonces hace el doble salto
				if (Input.pressed("up"))
				{
					//vy = -5;
					//ChangeState(JUMP);
					Saltar();
				}
				
			case FALL:
				vx = 0;
				numJumps = 0;
				
				if (_sprite.complete)
					ChangeState(IDLE);
				
			case DYING:
				vy += GC.G * HXP.elapsed;
				if (_sprite.complete)
				{
					//trace("COLISION CON PICOS!!!");
					HXP.scene = new GameScene();
				}
				
			//default:trace("ERROR: _state en update Indian");
		}
		Move();
		//trace(_state.getName() + " vx = " + vx + "  vy = " + vy + "  numJumps = " + numJumps);
		
		if (_state!= State.DYING && collide("arrow", x, y) != null)
		{
			ChangeState(DYING);
		}
		
		if (_state!= State.DYING && collide("exitLevel", x, y) != null)
		{
			HXP.scene = new EndScene();
		}
	}
	
	public function Move():Void
	{
		
		moveBy(vx, vy, colliders);
		
	}
	
	public function ChangeState(newState:State):Void
	{
		_state = newState;
		_sprite.play(anim[newState.getIndex()]);
	}
	
	public function Saltar()
	{
		if (numJumps < 2)
		{
			numJumps+=1;
			vy = -4;
			ChangeState(JUMP);
		}
	}
}
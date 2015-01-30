package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxObject;
import flash.geom.Point;
import scenes.*;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

enum StateTank
{
	IDLE; WALK; JUMP; TURN; SHOOT;
}

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Tank extends Entity
{
	private var shootFx:ShootFX;
	private var spTank:Spritemap;
	
	private var sndTankShoot:Sfx;
	private var sndWalking:Sfx;
	private var sndJumping:Sfx;
	private var sndTurn:Sfx;
	
	private var state:StateTank;
	
	// velocidad del tanque representada por un vector posicion de un punto
	private var v:Point;
	// aceleracion del tanque representada por un vector posicion de un punto
	private var a:Point;
	
	private var dirMirando:Int = 1;// 1 si es a derecha, -1 si es hacia izquierda
	
	private var salud:Int;
	
	private var refHelicopter:Helicopter;
	
	public function new(obj:TmxObject)
 {
		
		shootFx = new ShootFX(obj.x, obj.y);
		sndTankShoot = new Sfx(GC.SND_tank_shoot);
		sndWalking = new Sfx(GC.SND_tank_walk);
		sndJumping = new Sfx(GC.SND_tank_jump);
		sndTurn = new Sfx(GC.SND_tank_turn);
		
		spTank = new Spritemap(GC.IMG_tanque, 100, 100);
		
		spTank.add(IDLE.getName(), [0, 1, 2, 3, 2, 1], 6, true);
		spTank.add(WALK.getName(),	[43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65], 20, true);
		spTank.add(JUMP.getName(),	[7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27], 18, false);			
		spTank.add(TURN.getName(), [34,35,36,37,38,39,40,41,42], 9, false);

		state = IDLE;
		spTank.play(state.getName(), true);
		super(obj.x, obj.y, spTank);
		
		type = "tank";
		name = "Tank";// setear el name sirve para hacer referencias de la entidad (getInstance("Tank")) desde otra entidad
		spTank.centerOrigin();
		setHitbox(44,57,22,15);// (44, 57, 22, 15);
		
		Input.define("move_left", [Key.A, Key.LEFT]);
		Input.define("move_right", [Key.D, Key.RIGHT]);
		Input.define("move_up", [Key.W, Key.UP]);
		Input.define("move_down", [Key.S, Key.DOWN]);
		Input.define("shoot", [Key.SPACE]);
		
		salud = 100;
	}
	
	override public function update():Void
	{
		if (refHelicopter == null)
			refHelicopter = cast(HXP.scene.getInstance("Helicopter"), Helicopter);
		
		if(refHelicopter.active) HXP.setCamera(x - HXP.halfWidth, y - HXP.halfHeight*1.6);

		//trace("salud de tank: " + salud);
		
		super.update();
		
		switch(state)
		{
			case IDLE:
				v = new Point();
				// si NO hay piso, entonces cambia a saltando
				if (!ChocaraPiso())
				{
					ChangeState(JUMP);
				}
				
				if (MoveRight())
				{// si mira en esa direccion camina, sino se gira
					(!spTank.flipped) ? ChangeState(WALK) : ChangeState(TURN);
				}
				
				if (MoveLeft())
				{// si mira en esa direccion camina, sino se gira
					(spTank.flipped) ? ChangeState(WALK) : ChangeState(TURN);
				}
				
				if (MoveUp())
				{
					Saltar();
					ChangeState(JUMP);
				}
				
			// fin IDLE
			case WALK:
				v.x = (spTank.flipped) ? -1: 1;
				if (!ChocaraPiso() || MoveUp())
				{
					ChangeState(JUMP);
				}
				
				if ((!MoveLeft() && spTank.flipped) || (!MoveRight() && !spTank.flipped))
				{
					ChangeState(IDLE);
				}
				
				// fin WALK
			case JUMP:
				v.y += GC.G * HXP.elapsed;
				if (ChocaraPiso())
				{
					ChangeState(IDLE);
				}
				// fin JUMP
				
			case SHOOT:
				// fin SHOOT
				
			case TURN:
				if (spTank.complete)
				{
					spTank.flipped = !spTank.flipped;
					ChangeState(IDLE);
				}
				// fin TURN
			//default:trace("ERROR: state equivocado en Tank-update-switch");
		}
		
		if (state != TURN && Shooting() && !sndTankShoot.playing)
				Disparar();
		else
		 shootFx.SetVisible(false);
		
		if (collide("helicopter", x, y)!=null || salud <= 0)
			{
				HXP.scene.add(new Explosion(x, y, true));
				//HXP.scene.remove(this);
				this.active = false;
				//HXP.scene = new GameScene();
			}
		moveBy(v.x, v.y, "solid", true);
	}
	
/*
		Input.define("move_left", [Key.A, Key.LEFT]);
		Input.define("move_right", [Key.D, Key.RIGHT]);
		Input.define("move_up", [Key.W, Key.UP]);
		Input.define("move_down", [Key.S, Key.DOWN]);
		Input.define("shoot",[Key.SPACE]);
*/
	public function MoveLeft():Bool		{		return Input.check("move_left");	}
	public function MoveRight():Bool	{	 return Input.check("move_right");}
	public function MoveUp():Bool				{	 return Input.check("move_up");	  }
	public function MoveDown():Bool		{		return Input.check("move_down");	}
	public function Shooting():Bool		{		return Input.check("shoot");					}
	
	public function Disparar():Void
	{
		if (!spTank.flipped)
		{
			shootFx.SetPosition(x + 65, y+40);
		}
		else
		{
			shootFx.SetPosition(x - 25, y+40);
			shootFx.FlipSide();
		}
		
		sndTankShoot.play(0.35);
		shootFx.SetVisible(true);
		
		if (spTank.flipped)
		{
			HXP.scene.add(new Proyectil(x - 25, y + 15, 0, 15, GC.IMG_bala_tanque, -1));
		}
		else
		{
			HXP.scene.add(new Proyectil(x + 25, y + 15, 0, -15, GC.IMG_bala_tanque, 1));
		}
	}
	
	public function ChocaraPiso():Bool
	{
		return (collide("solid", x, y + 1)!=null);
	}
	
	public function ChangeState(newState:StateTank):Void
	{
		state = newState;
		spTank.play(state.getName(), true);
		
		PlaySounds();
	}
	
	public function Saltar():Void
	{
		(!spTank.flipped) ? (v = new Point(2, -4.5)) : (v = new Point( -2, -4.5));
	}
	
	public function PlaySounds():Void
	{
		if (state == WALK)
		{
			//sndWalking.volume = 0.25;
			sndWalking.play(0.15);
			sndWalking.loop(0.15);
		}
		else
			sndWalking.stop();
		
		if (state == JUMP)
		{
			sndJumping.play(0.15);
			//sndJumping.loop(1);
		}
		
		if (state == TURN)
		{
			sndTurn.play(0.15);
			//sndTurn.loop(1);
		}
		else
			sndTurn.stop();
	}
	
	public function Damage(damage:Int = 1):Void
	{
		salud-=damage;
	}
	
}
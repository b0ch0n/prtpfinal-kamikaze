package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import flash.events.MouseEvent;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import com.haxepunk.HXP;
import tweens.*;

import entities.*;
import scenes.*;

enum StateHelicopter
{
	IDLE; MOVE_MANEUVER; MOVE_SLOW; MOVE_FAST; SHOOTING;
}

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class Helicopter extends Entity
{
	private var shootFX:ShootFX;
	private var spHelicopter:Spritemap;
	private var sndFlying:Sfx;
	private var sndShoot:Sfx;
	
	private var state:StateHelicopter;
	private var v:Point;
	private var modV:Float;
	private var a:Point;
	private var refTank:Tank = null;
	
	private var tweenZoom:VarTween;
	private var zoomScale:Float;
	private var zoomIndex:Int;
	private var zoomTarget:Array<Float>;
	private var zoomDistances:Array<Float>;
	
	private var tweenCursorX:VarTween;
	private var tweenCursorY:VarTween;
	private var tweeenVx:VarTween;
	private var heliExplosion:Explosion;
	private var counter:Float;

	public function new(obj:TmxObject) 
	{
		sndFlying = new Sfx(GC.SND_helicopter);
		sndFlying.play(0.025);
		sndFlying.loop(0.025);
		
		sndShoot = new Sfx(GC.SND_helicopter_shoot);
		sndShoot.volume = 0.05;
		
		spHelicopter = new Spritemap(GC.IMG_helicoptero, 128, 128);
		spHelicopter.add(IDLE.getName(), [11, 12, 13], 4.5, true);
		spHelicopter.add(MOVE_MANEUVER.getName(), [10, 9], 4.5, true);		
		spHelicopter.add(MOVE_SLOW.getName(), [8, 7, 6, 5], 6, true);		
		spHelicopter.add(MOVE_FAST.getName(), [2, 1, 0], 4.5, true);		
		//spHelicopter.add("", [],, true);
		spHelicopter.play(IDLE.getName(), true);
		
		super(obj.x, obj.y, spHelicopter);
		type = "helicopter";
		name = "Helicopter";
		state = IDLE;
		spHelicopter.centerOrigin();
		spHelicopter.flipped = true;
		setHitbox(44, 57, 22, 35);
		shootFX = new ShootFX(x + halfWidth, y + halfHeight);
		
		v = new Point();
		zoomScale = 1;
		zoomIndex = 0;
		zoomTarget = [1, 0.875, 0.75, 0.625, 0.5, 0.45];
		zoomDistances = [300, 400, 500, 600, 700, 800];
		
		tweenCursorX = new VarTween();
		tweenCursorY = new VarTween();
		tweeenVx = new VarTween();
		addTween(tweenCursorX);
		addTween(tweenCursorY);
		addTween(tweeenVx);
		
		heliExplosion = null;
		counter = 0;
	}
	
	override public function update():Void
	{
		super.update();
		
		// obtengo la referencia al tanque
		if (refTank==null)		{			refTank = cast(HXP.scene.getInstance("Tank"), Tank);		}

		// actualizo el zoom de la camara
		SetZoom();
		
		// si presiono el disparo entonces lo realizo, sino oculto la imagen del fx de disparo
		(Input.mouseDown) ? Disparar() : shootFX.SetVisible(false);
		
		//modV = Math.sqrt(Math.pow(v.x, 2) + Math.pow(v.y, 2));
		
		if (active)
			FollowMouse();
		
		// si la posicion del cursor es menor que la del helicoptero
		/*if (Input.mouseX + HXP.camera.x < x )
		{
			v.x -= 0.01;
			if (v.x > 0)
				v.x -= 0.01;
		}
		else
		{
			v.x += 0.01;
			if (v.x < 0)
				v.x += 0.01;
		}*/
		
		
		if (distanceToPoint(Input.mouseX + HXP.camera.x, Input.mouseY + HXP.camera.y) < 50)
		{
			//if (Input.mouseX + HXP.camera.x < x )
				tweeenVx.tween(v, "x", 0, 1);
			//else
				//tweeenVx.tween(v, "x", 0.01, 1.5);
		}
		else
		{
			if (Input.mouseX + HXP.camera.x < x )
				tweeenVx.tween(v, "x", -0.7, 1);
			else
				tweeenVx.tween(v, "x", 0.7, 1);
		}
		
		
		//trace("state.getName() = "+spHelicopter.currentAnim.toString());
		
		//if (Input.mouseY + HXP.camera.y < y)
		//{
			//v.y -= 0.01;
			//if (v.y > 0)
				//v.y -= 0.01;
		//}
		//else
		//{
			//v.y += 0.01;
			//if (v.y < 0)
				//v.y += 0.01;
		//}
		
		var auxVX:Float = Math.abs(v.x);
		if (auxVX >= 0 && auxVX < 0.1)
		{
			spHelicopter.play(IDLE.getName());
			spHelicopter.flipped = (Input.mouseX + _camera.x > x);
		}
		else
		if (auxVX > 0.1 && auxVX < 0.3)
			spHelicopter.play(MOVE_MANEUVER.getName());
		else
		if (auxVX > 0.3 && auxVX < 0.5)
			spHelicopter.play(MOVE_SLOW.getName());
		else
			spHelicopter.play(MOVE_FAST.getName());
		
		//moveBy(v.x, v.y, ["solid", "tank"]);
		
		if (collide("solid", x, y) != null || collide("tank", x, y) != null)
		{
			//scene.remove(this);
			this.active = false;
			this.visible = false;
			sndShoot.stop();
			sndFlying.stop();
			
			//heliExplosion = new Explosion(x, y);// x + halfWidth, y + halfHeight));
			//scene.add(heliExplosion);
			HXP.scene.add(new Explosion(x, y, true));
			
		}
		
		if (heliExplosion != null)
		{
			counter += HXP.elapsed;
			if(counter>4)			HXP.scene = new GameScene();
		}
	}
	
	public function FollowMouse():Void
	{
		tweenCursorX.tween(this, "x", Input.mouseX + HXP.camera.x, 1);
		tweenCursorY.tween(this, "y", Input.mouseY + HXP.camera.y, 1);
	}
	
	public function SetZoom():Void
	{
/*
		zoomScale = 1;                  		zoomIndex = 0;
		zoomScales = [1, 0.875, 0.75, 0.625, 0.5, 0.45];
		zoomDistances = [200, 300, 400, 500, 600, 700];
*/
		var distance:Float = distanceToPoint(refTank.x, refTank.y);
		/*
			*  si distancia > 200, index = 1, zoom = 0.875
			*  si distancia > 300, index = 2, zoom = 0.75
			*  si distancia > 400, index = 3, zoom = 0.625
			*  etc
			* */
		// si la distancia vertical entre el tanque y el helicoptero
		// es mayor a (w=640,h=480)
		zoomIndex = 0;
		for ( i in 0...zoomDistances.length)		{
			if (distance > zoomDistances[i])			{
				zoomIndex++;
			}
		}

		if (zoomScale > zoomTarget[zoomIndex])
		{
			zoomScale-= 0.005;
			if (zoomScale < zoomTarget[zoomIndex])
				zoomScale = zoomTarget[zoomIndex];
		}
		else
			if (zoomScale < zoomTarget[zoomIndex])
			{
				zoomScale += 0.005;
				if (zoomScale > zoomTarget[zoomIndex])
					zoomScale = zoomTarget[zoomIndex];
			}

		HXP.screen.scale = zoomScale;		
	}
	
	public function Disparar():Void
	{
		// PI = 1 radian = 180º
		// PI/2 = 1/2 radian = 90º
		// 105º -----> (105º * PI) / 180º =
		if (!sndShoot.playing)
		{
			sndShoot.volume = 0.1;
			sndShoot.play(0.1);
		}
		
		if (spHelicopter.currentAnim == IDLE.getName())// quieto
		{
			Shooting(90,0,30);
		}
		else
		if (spHelicopter.currentAnim == MOVE_MANEUVER.getName())// moviendo_maniobra
		{
			(spHelicopter.flipped) ? Shooting(105, 3, 28): Shooting(75, -3, 28);
		}
		else
		if (spHelicopter.currentAnim == MOVE_SLOW.getName())// moviendo_lento
		{
			(spHelicopter.flipped) ? Shooting(130, 14, 27): Shooting(50, -14, 27);
		}
		else
		if (spHelicopter.currentAnim == MOVE_FAST.getName())// moviendo_rapido
		{
			(spHelicopter.flipped) ? Shooting(150, 35, 28): Shooting(30, -35, 28);
		}
		
		shootFX.SetVisible(true);
		
	}
	
	public function Shooting(angle:Float=0,deltaX:Float=0,deltaY:Float=0):Void
	{
		shootFX.SetAngle(angle);
		shootFX.SetPosition(x+halfWidth + deltaX, y +halfHeight+ deltaY);		
		scene.add(new Proyectil(x + deltaX, y + deltaY, angle, 10, GC.IMG_bala_tanque));		
	}
	
	
}
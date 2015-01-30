package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import flash.geom.Point;
import scenes.GameScene;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class Explosion extends Entity
{
	private var spExplosion:Spritemap = null;
	private var sndExplosion:Sfx;
	private var auxAngle:Float = 0;
	private var auxX:Float = 0;
	private var auxY:Float = 0;
	private var posCamera:Point;
	private var resetGame:Bool;

	public function new(x:Float = 0, y:Float = 0, resetGame:Bool = false)
	{
		spExplosion = new Spritemap(GC.IMG_explosion, 96, 96);
		spExplosion.add("explotando", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 10, false);
		spExplosion.play("explotando", true);
		spExplosion.centerOrigin();
		super(x, y, spExplosion);
		setHitbox(spExplosion.width, spExplosion.height,50,50);
		
		sndExplosion = new Sfx(GC.SND_explosion);
		sndExplosion.volume = 0.15;
		sndExplosion.play(0.15);
		auxX = HXP.camera.x;
		auxY = HXP.camera.y;
		posCamera = new Point(auxX, auxY);
		
		type = "explosion";
	 this.resetGame = resetGame;
	}
	
	override public function update():Void
	{
		if(spExplosion.complete)
		{
			HXP.scene.remove(this);
			HXP.setCamera(auxX, auxY);//posCamera.x, posCamera.y);//
			if (resetGame)
				HXP.scene = new GameScene();
		}
		else
		{
			auxAngle++;
			var factorParX:Float = ((HXP.rand(10) / 2) == 0 ? 5 : -5);
			var factorParY:Float = ((HXP.rand(10) / 2) == 0 ? 5 : -5);
			HXP.setCamera(auxX + factorParX * Math.cos(auxAngle), auxY + factorParY * Math.sin(auxAngle));
		}		
	}
	
	public function Finished():Bool
	{
		return spExplosion.complete;
	}
}
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class ShootFX extends Entity
{
	private var spShoot:Spritemap;

 override	public function new(x:Float = 0, y:Float=0) 
	{
		spShoot = new Spritemap(GC.IMG_fx_disparo, 50, 50);
		spShoot.add("disparando", [0, 1, 2], 10, true);
		spShoot.play("disparando", true);
		spShoot.visible = true;
		spShoot.centerOO();
		spShoot.scale = 0.75;
		graphic = spShoot;
		super(x, y, graphic);
		type = "shoot_fx";
		HXP.scene.add(this);
	}
	
	override public function update():Void
	{
		super.update();
	}
	
	public function SetPosition(x:Float, y:Float):Void
	{
		super.x = x;
		super.y = y;
	}
	
	public function SetVisible(visible:Bool):Void
	{
		spShoot.visible = visible;
	}
	
	public function Shooting():Bool
	{
		return !spShoot.complete;
	}
	
	public function FlipSide():Void
	{
		spShoot.flipped = !spShoot.flipped;
	}
	
	public function SetAngle(angle:Float):Void
	{
		spShoot.angle = angle;
	}
}
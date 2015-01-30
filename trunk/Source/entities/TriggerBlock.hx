package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tweens.misc.ColorTween;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import Std;
import com.haxepunk.World;
import haxe.ds.Vector.Vector;
//import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;

import entities.*;

enum ColorTrigger
{
	AZUL;
	DORADO;
	LILA;
	NARANJA;
	NEGRO;
	VERDE;
}
/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class TriggerBlock extends Entity
{
	//private var _color:UInt = Std.random(6);
	private var touched:Bool = false;
	private var _sprite:Spritemap;
	private var _colorTrigger:ColorTrigger;
	private var _strColor:Array<String>;
	private var timer:Float = 5;
	
	override public function new(obj:TmxObject)
	{
		_colorTrigger = SetColorTrigger(Std.random(6));
		_strColor = ["azul", "dorado", "lila", "naranja", "negro", "verde"];

		super(obj.x, obj.y);
		setHitbox(32,32);
		_sprite = new Spritemap(GC.IMG_color_blocks, 32, 32);
		_sprite.add(_strColor[0], [0], 0, false);
		_sprite.add(_strColor[1], [1], 0, false);
		_sprite.add(_strColor[2], [2], 0, false);
		_sprite.add(_strColor[3], [3], 0, false);
		_sprite.add(_strColor[4], [4], 0, false);
		_sprite.add(_strColor[5], [5], 0, false);
		
		_sprite.play(_strColor[_colorTrigger.getIndex()]);
		graphic = _sprite;
		type = "trigger_block";		
	}
	
	override public function update():Void
	{
		timer += HXP.elapsed;
		if (!touched && timer>5
		&& (collide("indian", x, y - 1) != null
		||  collide("indian", x, y + 1) != null
		||  collide("indian", x - 1, y) != null
		||  collide("indian", x + 1, y) != null
		||  collide("arrow", x, y) != null))
		{
			ShootTotemColor();
		}

		if (touched
		&&  collide("indian", x, y - 1) == null
		&&  collide("indian", x, y + 1) == null
		&&  collide("indian", x - 1, y) == null
		&&  collide("indian", x + 1, y) == null)
		{
			touched = false;
		}
	}
	
	public function SetTouched():Void
	{
	 touched = true;
		
	}
	
	public function SetColorTrigger(num:UInt):ColorTrigger
	{
		switch(num)
		{
			case 0: return AZUL;
			case 1: return DORADO;
			case 2: return LILA;
			case 3: return NARANJA;
			case 4: return NEGRO;
			case 5: return VERDE;
			default:trace("ERROR: num en function SetColorTrigger de TriggerBlock");
		}
		return AZUL;
	}
	
	public function ShootTotemColor():Void
	{
		//trace("Cambio de bloque!!!");
		var totemList:Array<Totem> = [];
		scene.getClass(Totem, totemList);
		
		for (t in 0...totemList.length)
		{
			if (totemList[t].GetTotemColor() == _colorTrigger.getName())
				totemList[t].Shoot();
		}
		
		timer = 0;
		touched = true;
		_colorTrigger = SetColorTrigger(Std.random(6));
		_sprite.play(_strColor[_colorTrigger.getIndex()]);
	}
}
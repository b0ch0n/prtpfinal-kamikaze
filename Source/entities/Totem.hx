package entities;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tmx.TmxObject;
import flash.geom.Point;
import com.haxepunk.Graphic;
import com.haxepunk.Entity;
import Std;
import GC;
/*
enum Direction { 
	UP;
 DOWN;
 LEFT;
 RIGHT;
}
*/
enum StateTotem {
	CLOSED;
	OPENING;
	CLOSING;
	//OPEN;
}


enum ColorTotem
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
 * @author ... Marcelo Ruben Guardia
 */
class Totem extends Entity
{
	private var _sprite:Spritemap;
	private var _state:StateTotem;
	private var _colorTotem:ColorTotem;
	private var _direction:Direction;
	private var shoot_down:Bool = false;
	private var shoot_left:Bool = false;
	private var shoot_right:Bool = false;
	private var shoot_up:Bool = false;
	private var anim:Array<String>;
	private var dirShoot:Array<Bool>;
	
	override public function new(obj:TmxObject) 
	{
		_state = StateTotem.CLOSED;		
		anim = ["closed","opening","closing"];
		super(obj.x, obj.y - 32);
		/*
		dirShoot[Direction.DOWN.getIndex()]  = (Std.string(obj.custom.resolve("down"))  == "true") ? true : false;
		dirShoot[Direction.LEFT.getIndex()]  = (Std.string(obj.custom.resolve("left"))  == "true") ? true : false;
		dirShoot[Direction.RIGHT.getIndex()] = (Std.string(obj.custom.resolve("right")) == "true") ? true : false;
		dirShoot[Direction.UP.getIndex()]    = (Std.string(obj.custom.resolve("up"))    == "true") ? true : false;
		*/
		//trace("sdown = "+shoot_down+" sleft = "+shoot_left+" sright = "+shoot_right+" sup = "+shoot_up);
		dirShoot = [
		 (Std.string(obj.custom.resolve("down"))  == "true") ? true : false
		,(Std.string(obj.custom.resolve("left"))  == "true") ? true : false
		,(Std.string(obj.custom.resolve("right")) == "true") ? true : false
		,(Std.string(obj.custom.resolve("up"))    == "true") ? true : false
		];
		
		var color:String = obj.name.toString();
		_colorTotem = SetColor(color);
		_sprite = new Spritemap("gfx/totem-" + color.toString() + ".png", 64, 64);
		_sprite.scale = 0.5;
		
		_sprite.add(anim[CLOSED.getIndex()], [0], 0, false);
		_sprite.add(anim[OPENING.getIndex()], [1, 2, 3, 4, 5, 6], 12, false);
		_sprite.add(anim[CLOSING.getIndex()], [6, 5, 4, 3, 2, 1], 12, false);
		_sprite.play(anim[_state.getIndex()]);
		
		graphic = _sprite;
	}
	
	override public function update():Void
	{
		super.update();
		//trace("_state = "+_state.getName());
		
		switch(_state)
		{
			case CLOSED:
				_sprite.play(anim[_state.getIndex()]);
				
			case OPENING:
				if (_sprite.complete)
				{
					ShootArrow();
					_state = CLOSING;
					_sprite.play(anim[_state.getIndex()]);
				}
			case CLOSING:
				if (_sprite.complete)
				{
					//scene.add(new Arrow());
					_state = CLOSED;
					_sprite.play(anim[_state.getIndex()]);
				}
				
			//default:	trace("ERROR: en _state en update de Totem!!!");
		}
	}
	
	public function Shoot():Void
	{		
		if (_state == CLOSED)
		{
			_state = OPENING;
			_sprite.play(anim[_state.getIndex()]);
		}		
	}
	
	public function SetColor(strColor:String):ColorTotem
	{
		if (strColor=="azul")					return AZUL;
		else
		if (strColor=="dorado")			return DORADO;
		else
		if (strColor=="lila")					return LILA;
		else
		if (strColor=="naranja")		return NARANJA;
		else
		if (strColor=="negro")				return NEGRO;
		
		return VERDE;		
	}
	
	public function GetTotemColor():String
	{
		return _colorTotem.getName();
	}
	
	public function ShootArrow():Void
	{
		//var angle:Float = 0;
		var shooted:Bool = false;
		var count:Int = 1;
		var dir:Int = Std.random(4);
		//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
		
		if (dirShoot[dir])
		{
			get_scene().add(new Arrow(this.x+16, this.y+16, dir));
			//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
		}
		else
		{
			count+=1;
			dir = (dir+1) % 4;
			if (dirShoot[dir]==true)
			{
				get_scene().add(new Arrow(this.x+16, this.y+16, dir));
				//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
			}
			else
			{
				count+=1;
				dir = (dir+1) % 4;
				if (dirShoot[dir]==true)
				{
					get_scene().add(new Arrow(this.x+16, this.y+16, dir));
					//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
				}
				else
				{
					count+=1;
					dir = (dir+1) % 4;
					if (dirShoot[dir]==true)
					{
						get_scene().add(new Arrow(this.x+16, this.y+16, dir));
						//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
					}
				}
			}
		}
		
			/*
			while (!shooted)
			{
				count++;
				dir = (dir++) % 4;
				if (dirShoot[dir])
				{
					//get_scene().add(new Arrow());
					shooted = true;
				}
				//trace("count = "+count+"  dirShoot[dir] = "+dirShoot[dir]+"  dir = "+dir);
			}
			*/
	}
	
}
package entities;

import com.haxepunk.Entity;
import com.haxepunk.tmx.TmxObject;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class ExitLevel extends Entity
{

	override public function new(obj:TmxObject) 
	{
		super(obj.x, obj.y);
		setHitbox(obj.width, obj.height);
		type="exitLevel";
	}
	
}
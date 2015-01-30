package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.tmx.TmxObject;
import haxe.Timer;
import com.haxepunk.HXP;

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class MummyGenerator extends Entity
{
	private var spMummyGenerator:Spritemap;
	//private var timerGenerator:Timer;
	private var counter:Float;

	public function new(obj:TmxObject)
	{
		super(obj.x, obj.y);
		
		spMummyGenerator = new Spritemap(GC.IMG_momia_generador, 64, 64);
		switch(obj.custom.resolve("tipo").toString())
		{
			case "cara1":				spMummyGenerator.add("cara", [0]);
			case "cara2":				spMummyGenerator.add("cara", [1]);
			case "cara3":				spMummyGenerator.add("cara", [2]);
		}
		
		setHitbox(spMummyGenerator.width, spMummyGenerator.height);
		spMummyGenerator.play("cara");
		
		//timerGenerator = new Timer(5000);
		counter = 0;

		graphic = spMummyGenerator;
		layer = 1;
		type = "mummy_generator";
		HXP.scene.add(new Mummy(null, x + 32, y));
	}
	
	override public function update():Void
	{
		super.update();
		//timerGenerator.
		counter += HXP.elapsed;
		if (counter > 10)
		{
			scene.add(new Mummy(null, x + 32, y));
			counter = 0;
		}
		
		if (collide("explosion", x, y) != null)
		{
			scene.remove(this);
		}
	}
	
}
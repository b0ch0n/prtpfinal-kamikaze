package scenes;

import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxState;
import flixel.util.FlxPoint;
import nape.geom.Vec2;
import nape.space.Space;
import flixel.FlxG;
import nape.util.Debug;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class GameNapeState extends FlxState
{
	private var levels:Array < String >;
	private var currentLevel:Int;
	//private var tiledLevelNape:TiledLevelNape;
	public var tiledLevel:TiledLevel;
	private var space:Space;
	//private var debugNape:Debug;
	
	private var zoom:Float = 0.5;

	override public function create():Void
	{
		
		SetZoom(0.0);
		//FlxG.resizeGame(Std.int(FlxG.width * FlxG.camera.zoom), Std.int(FlxG.height * FlxG.camera.zoom));
		//bgColor = 0xffaaaaaa;
		levels = ["level_00"/*,"level_01","level_02"*/, "level_test"];
		
		#if debug
			currentLevel = levels.length - 1;// si es modo Debug, cargo el level_test, es decir el ultimo
		#else
			currentLevel = 0;
		#end
		
		SetupSpaceNape();
		
		// cargo los tilemaps del nivel
		tiledLevel = new TiledLevel( "maps/" + levels[currentLevel] + ".tmx" );
		
		// agrego el tilemap de render de fondo
	 add(tiledLevel.renderTiles);
		
		// cargando los objetos del nivel
		tiledLevel.LoadObjects(this);
		
		// si lo hubiera, cargo otros tilemaps de render del nivel
		//add(tiledLevel.otrosRenderTiles);
		
		// carga de UI para Ayudas, Score, Opciones, Menu, Etc
		// tambien se puede hacer la carga de objetos del nivel
		// asignando la capa del grupo correspondiente
		//LoadUI();
		
	}
	
	public function GetSpace():Space
	{
		return space;
	}
	
	public function SetupSpaceNape():Void
	{
		var gravity = new Vec2(0, 981);
		space = new Space(gravity);
		//debugNape = new Debug();
		//debugNape.display = FlxG.stage.getRect();
		//debugNape.drawBodies = true;
		
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.UP && zoom < 0.5)
		{
			//zoom += 0.1;
			SetZoom(0.1);
		}
		else
		if (FlxG.keys.justPressed.DOWN && zoom > 0.2)
		{
			//zoom -= 0.1;
			SetZoom(-0.1);
		}
		
				
	}
	
	override public function draw():Void
	{
		super.draw();
		for (b in 0...space.bodies.length)
		{
			Debug.createGraphic(space.bodies.at(b));
		}
		
	}
	

	public function SetZoom(deltaZoom:Float = 1.0):Void
	{
		zoom += deltaZoom;
		FlxG.camera.zoom = zoom;
	}
	
}
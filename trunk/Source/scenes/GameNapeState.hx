package scenes;

import flash.display.Stage;
import flash.geom.Point;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.effects.FlxFlicker;
import flixel.FlxObject;
//import flixel.FlxState;
import flixel.util.FlxPoint;
import nape.geom.Vec2;
import nape.space.Space;
import flixel.FlxG;
import nape.util.Debug;
//import openfl.display.StageDisplayState;
//import openfl.display.StageAlign;
import flash.display.StageAlign;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class GameNapeState extends FlxNapeState
{
	private var levels:Array < String >;
	private var currentLevel:Int;
	public var tiledLevel:TiledLevel;	
	private var zoom:Float = 0.5;

	override public function create():Void
	{
		super.create();
		
		SetZoom(0.0);
		bgColor = 0x999;
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
		tiledLevel.LoadObjects();// this);
		
		// si lo hubiera, cargo otros tilemaps de render del nivel
		//add(tiledLevel.otrosRenderTiles);
		
		// carga de UI para Ayudas, Score, Opciones, Menu, Etc
		// tambien se puede hacer la carga de objetos del nivel
		// asignando la capa del grupo correspondiente
		//LoadUI();
		
	}

	public function SetupSpaceNape():Void
	{
		//var gravity = 
		FlxNapeState.space.gravity = new Vec2(0, 981);
		napeDebugEnabled = true;
	}
	
	//public function GetSpace():Space
	//{
		//return space;
	//}
		
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.O && zoom < 0.5)
		{
			//zoom += 0.1;
			SetZoom(0.1);
		}
		else
		if (FlxG.keys.justPressed.L && zoom > 0.2)
		{
			//zoom -= 0.1;
			SetZoom(-0.1);
		}
		
				
	}
	
	override public function draw():Void
	{
		super.draw();
		//for (b in 0...space.bodies.length)
		//{
			//Debug.createGraphic(space.bodies.at(b));
		//}
		
	}
	

	public function SetZoom(deltaZoom:Float = 1.0):Void
	{
		//private static var deltaX;
		//private static var deltaY;
		
		zoom += deltaZoom;
		FlxG.camera.zoom = zoom;
		//FlxG.camera.follow(new FlxObject(FlxG.stage.stageWidth / 2, FlxG.stage.stageHeight / 2, FlxG.stage.stageWidth / 2, FlxG.stage.stageHeight / 2));
		//FlxG.stage.align = StageAlign.LEFT;//  "CENTER";// StageAlign.BOTTOM;
		//FlxG.camera.focusOn(new FlxPoint(FlxG.stage.width / 2, FlxG.stage.height / 2));
		//FlxG.camera.x = 100;// FlxG.stage.width / FlxG.camera.zoom;
		//FlxG.camera.y = ;
		//FlxG.camera.screen.setPosition(tiledLevel.width * FlxG.camera.zoom,tiledLevel.height * FlxG.camera.zoom);// .y = 100;
		
	}
	
}
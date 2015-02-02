package scenes;

import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import nape.geom.Vec2;
import nape.space.Space;
import flixel.FlxG;
import nape.util.Debug;
import flash.display.StageAlign;
import flixel.plugin.MouseEventManager;

import flixel.util.FlxSpriteUtil.DrawStyle;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class GameNapeState extends FlxNapeState
{
	private var canvas:FlxSprite;
	private var levels:Array < String >;
	private var currentLevel:Int;
	public var tiledLevel:TiledLevel;	
	private var zoom:Float = 5.0;// 0.5;
	
	private var minZoom:Float = 2.0;
	private var maxZoom:Float = 5.0;
	private var deltaZoom:Float = 1.0;

	override public function create():Void
	{
		//trace("FlxNapeState.hx:146: Next line comment b0ch0n!!! '//space.step(FlxG.elapsed, velocityIterations, positionIterations);'");
		super.create();
		FlxG.plugins.add(new MouseEventManager());
		canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		add(canvas);
		//FlxG.game.width = 640 * 6;
		//
		//FlxG.game.height = 480 * 6;
		//FlxG.resizeGame(640 * 6, 480 * 6);
		//SetZoom(4.0);// 0.1);
		bgColor = 0x000999;
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
		
		if (FlxG.keys.justPressed.O && zoom < maxZoom)
		{
			//zoom += 0.1;
			SetZoom(deltaZoom);// 0.1);
			//canvas.setGraphicSize(FlxG.width, FlxG.height);
		}
		else
		if (FlxG.keys.justPressed.L && zoom > minZoom)
		{
			//zoom -= 0.1;
			SetZoom( -deltaZoom);// -0.1);
			//canvas.setGraphicSize(FlxG.width, FlxG.height);
		}
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new GameNapeState());
		}
		
		if (FlxG.mouse.wheel != 0)
		{
			// Mouse wheel logic goes here, for example zooming in / out:
			FlxG.camera.zoom += (FlxG.mouse.wheel / 15);
			trace("FlxG.camera.zoom = "+FlxG.camera.zoom);
			//canvas.setGraphicSize(FlxG.width, FlxG.height);
		}
	}
	
	override public function draw():Void
	{
		super.draw();
		//for (b in 0...space.bodies.length)
		//{
			//Debug.createGraphic(space.bodies.at(b));
		//}
		//var r = new Rectangle(FlxG.stage.x, FlxG.stage.y, FlxG.stage.width, FlxG.stage.height);
		//var r = new Rectangle(FlxG.camera.x, FlxG.camera.y, FlxG.camera.width, FlxG.camera.height);
		
		//FlxSpriteUtil.drawRect(canvas, r.x, r.y, r.width, r.height, FlxColor.CYAN);
		
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
package scenes;

import entities.KamikazeMO2D;
import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import nape.geom.Vec2;
import nape.space.Space;
import flixel.FlxG;
import nape.util.Debug;
import flash.display.StageAlign;
import flixel.plugin.MouseEventManager;
import openfl.display.BitmapData;

import flixel.util.FlxSpriteUtil.DrawStyle;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;

import flixel.addons.display.FlxZoomCamera;

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class GameNapeFlxZoomCamera extends FlxNapeState
{
	private var canvas:FlxSprite;
	private var levels:Array < String >;
	private var currentLevel:Int;
	public var tiledLevel:TiledLevel;	
	private var zoom:Float = 5.0;// 0.5;
	
	private var minZoom:Float = 2.0;
	private var maxZoom:Float = 5.0;
	private var deltaZoom:Float = 1.0;
	
	private var countZoom:Int = 0;
	
	private var zoomCamera:FlxZoomCamera;
	
	private var kamikaze:KamikazeMO2D;
	private var targetCamera:FlxObject;

	override public function create():Void
	{
		super.create();

		zoomCamera = new FlxZoomCamera(0, 0, 3840, 2880, 1.0);// 640, 480);
		FlxG.cameras.reset(zoomCamera);
		
		canvas = new FlxSprite(FlxG.camera.x,FlxG.camera.y);
		//canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.ROYAL_BLUE);// .TRANSPARENT);
		canvas.makeGraphic(3840, 2880, FlxColor.ROYAL_BLUE);// .TRANSPARENT);
		add(canvas);
		

		bgColor = 0x000999;
		levels = ["level_00"/*,"level_01","level_02"*/, "level_test", "level_test2"]; // 0,1,2,3
		
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
	
	// static public para que se pueda acceder con GameNapeState.SetKamikaze
	public function SetKamikaze(refKamikaze:KamikazeMO2D):Void
	{
		kamikaze = refKamikaze;
	}
	
	// target al que tiene que seguir la camara
	public function SetTargetCamera(targetCamera:FlxObject):Void
	{
	
		this.targetCamera = targetCamera;
		FlxG.camera.target = targetCamera;		
	}

	public function SetupSpaceNape():Void
	{
		FlxNapeState.space.gravity.setxy(0, 981);// (new Vec2(0, 981));
		//FlxNapeState.space.step(0.016);// , velocityIterations, positionIterations);
		napeDebugEnabled = true;
		this.active = true;
	}

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
			FlxG.switchState(new GameNapeFlxZoomCamera());
		}
		
		if (FlxG.mouse.wheel != 0)
		 ZoomWheel();

		MoveCamera(5);
		
		zoomCamera.target = targetCamera;
		zoomCamera.follow(targetCamera);
		
		zoomCamera.update();
		//FlxG.camera.update();
		//FlxG.camera.x = targetCamera.x - FlxG.camera.width * 0.5;
		//canvas.setPosition(FlxG.camera.x, FlxG.camera.y);
	}
	
	public function ZoomWheel():Void
	{
		// zoomIn 1 ; x = -480 ; y = -360
		// zoomIn 2 ; x = -960 ; y = -720
		// zoomIn 3 ; x = -1440; y = -1080
		
		var zoomIn : Bool = FlxG.mouse.wheel > 0;
		var zoomOut : Bool = FlxG.mouse.wheel < 0;
		var deltaZoom = 0.25;// 1 / 3.0;
		var factorX = 480.0;
		var factorY = 360.0;
		var factorScale = 1.0;
		if (zoomOut)
		{
			zoomCamera.targetZoom -= deltaZoom;
			deltaZoom *= -1.0;
			factorScale *= -1.0;
		}
		else
		{
			zoomCamera.targetZoom += deltaZoom;
		}

		trace("FlxG.camera.zoom = " + FlxG.camera.zoom);
	}
	
	public function MoveCamera(delta:Int):Void
	{
		var moving:Bool = false;
		if (FlxG.keys.pressed.LEFT)
		{
			FlxG.camera.x += delta;
			//FlxG.camera.screen.setPosition(FlxG.camera.screen.x + delta, FlxG.camera.screen.y);
			moving = true;
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.camera.x-=delta;
			moving = true;
		}
		
		if (FlxG.keys.pressed.UP)
		{
			FlxG.camera.y+=delta;
			moving = true;
		}
		
		if (FlxG.keys.pressed.DOWN)
		{
			FlxG.camera.y -= delta;
			moving = true;
		}

		if (moving)
		{
			trace("FlxG.camera.x = " + FlxG.camera.x + "  FlxG.camera.y = " + FlxG.camera.y);
		}
	}
	
	public function Zoom(zoomUp:Bool):Void
	{
		if (zoomUp)
			countZoom++;
		else
		 countZoom--;
		
		switch(countZoom)
		{
			case 1:
				FlxG.camera.setPosition(FlxG.camera.x -100 , FlxG.camera.y -100);
			
			case 2:
				FlxG.camera.setPosition(FlxG.camera.x -200 , FlxG.camera.y -200);
			
			case 3:
				FlxG.camera.setPosition(FlxG.camera.x -300 , FlxG.camera.y -300);
			
			case 4:
				FlxG.camera.setPosition(FlxG.camera.x -400 , FlxG.camera.y -400);
			
			case -1:
				FlxG.camera.setPosition(FlxG.camera.x +100 , FlxG.camera.y +100);
			
			case -2:
				FlxG.camera.setPosition(FlxG.camera.x +200 , FlxG.camera.y +200);
			
			case -3:
				FlxG.camera.setPosition(FlxG.camera.x +300 , FlxG.camera.y +300);
			
			case -4:
				FlxG.camera.setPosition(FlxG.camera.x +400 , FlxG.camera.y +400);
			
		}
	}

	public function SetZoom(deltaZoom:Float = 1.0):Void
	{
		//private static var deltaX;
		//private static var deltaY;
		
		zoom += deltaZoom;
		FlxG.camera.zoom = zoom;
	}
	
}
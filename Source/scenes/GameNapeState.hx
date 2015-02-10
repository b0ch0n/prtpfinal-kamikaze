package scenes;

import entities.KamikazeMO2D;
import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.system.scaleModes.BaseScaleMode;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import nape.geom.AABB;
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
import flixel.input.mouse.FlxMouse;
import flixel.FlxGame;


/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class GameNapeState extends FlxNapeState
{
	private var canvas:FlxSprite;
	private var levels:Array < String >;
	private var currentLevel:Int;
	public var tiledLevel:TiledLevel;	
	//private var zoom:Float = 5.0;// 0.5;
	
	//private var minZoom:Float = 2.0;
	//private var maxZoom:Float = 5.0;
	//private var deltaZoom:Float = 1.0;
	
	//private var countZoom:Int = 0;
	
	private var zoomCamera:FlxZoomCamera;
	
	private var kamikaze:KamikazeMO2D;
	private var targetCamera:FlxObject;

	override public function create():Void
	{
		super.create();
		//FlxNapeState.space.world.allowMovement = true;
		
		
		//zoomCamera = new FlxZoomCamera(0, 0, 3840, 2880, 1.0);// 640, 480);
		var factor = 6;
		zoomCamera = new FlxZoomCamera(0, 0, 640*factor, 480*factor, 1.0);// 640, 480);
		//FlxG.cameras.reset(zoomCamera);
		//
		//FlxG.camera.zoom = 3.0;
		//if (FlxG.fullscreen)
			//FlxG.camera.zoom = 9.0;
		//
		canvas = new FlxSprite();// FlxG.camera.x, FlxG.camera.y);//FlxG.game.x, FlxG.game.y);//
		//canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.ROYAL_BLUE);// .TRANSPARENT);
		canvas.loadGraphic("gfx/backgrounds/bg_01.png");
		canvas.scale.set( 2.0, 2.0);
		canvas.setPosition(320.0, 240.0);
		//canvas.makeGraphic(3840, 2880, FlxColor.ROYAL_BLUE);// .TRANSPARENT);
		add(canvas);
		

		bgColor = 0x000999;
		//levels = ["level_00"/*, "level_01", "level_02"*/, "level_test"];// , "level_test2"]; // 0,1,2,3
		levels = ["level_00"/*, "level_01", "level_02"*/, "level_test", "level_test2"];
		
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
		//FlxG.camera.target = targetCamera;		
	}

	public function SetupSpaceNape():Void
	{
		FlxNapeState.space.gravity.setxy(0, 981);
		napeDebugEnabled = true;
		this.active = true;
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new GameNapeState());
		}
		
		if (FlxG.mouse.wheel != 0)
		 ZoomWheel();

		MoveCamera(32);
		
		if (FlxG.mouse.justReleasedRight)
			MouseOnClick();
		
		MoveScreen(5);
		
		//MousePositions();
		
		//zoomCamera.update();
		//FlxG.camera.follow(targetCamera);
		

		MoveCanvas();
		MoveStage();
		//zoomCamera.focusOn(new FlxPoint(targetCamera.x, targetCamera.y));
	}
	
	public function MoveStage():Void
	{
		if (FlxG.keys.pressed.F)
		{
			trace("FlxG.stage.mouseX = "+FlxG.stage.mouseX+"  FlxG.stage.mouseY = "+FlxG.stage.mouseY);
		}
	}
	
	public function MoveCanvas():Void
	{
		var deltaX = 16.0;
		var deltaY = 16.0;
		if (FlxG.keys.justPressed.W)
		{
			canvas.setPosition(canvas.x, canvas.y - deltaY);
			trace("canvas.x = " + canvas.x + "  canvas.y = " + canvas.y);
		}
		else
		if (FlxG.keys.justPressed.S)
		{
			canvas.setPosition(canvas.x, canvas.y + deltaY);
			trace("canvas.x = " + canvas.x + "  canvas.y = " + canvas.y);
		}
				if (FlxG.keys.justPressed.D)
		{
			canvas.setPosition(canvas.x + deltaX, canvas.y);
			trace("canvas.x = " + canvas.x + "  canvas.y = " + canvas.y);
		}
		else
		if (FlxG.keys.justPressed.A)
		{
			canvas.setPosition(canvas.x - deltaX, canvas.y);
			trace("canvas.x = " + canvas.x + "  canvas.y = " + canvas.y);
		}
	}
	
	public function MousePositions():Void
	{
		trace("FlxG.mouse.x = " + FlxG.mouse.x+"   FlxG.mouse.screenX = " + FlxG.mouse.screenX);
		trace("FlxG.mouse.y = " + FlxG.mouse.y+"   FlxG.mouse.screenY = " + FlxG.mouse.screenY);
		trace("FlxG.mouse.getScreenPosition().toString() =" + FlxG.mouse.getScreenPosition().toString());
		trace("FlxG.mouse.getWorldPosition().toString() =" + FlxG.mouse.getWorldPosition().toString());
		trace("");
	}

	public function MoveScreen(delta:Int):Void
	{
  var moving:Bool = false;
		if (FlxG.keys.pressed.LEFT)
		{
			FlxG.camera.screen.x += delta;
			moving = true;
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.camera.screen.x-=delta;
			moving = true;
		}
		
		if (FlxG.keys.pressed.UP)
		{
			FlxG.camera.screen.y+=delta;
			moving = true;
		}
		
		if (FlxG.keys.pressed.DOWN)
		{
			FlxG.camera.screen.y -= delta;
			moving = true;
		}

		if (moving)
		{
			trace("FlxG.camera.screen.x = " + FlxG.camera.screen.x + "  FlxG.camera.screen.y = " + FlxG.camera.screen.y);
		}
	}
	
	override public function draw():Void
	{
		super.draw();
		
		//FlxSpriteUtil.drawRect(this, FlxG.stage.x, FlxG.stage.y, FlxG.stage.width, FlxG.stage.height, FlxColor.CYAN, LineStyle, FillStyle, DrawStyle);
		//FlxSpriteUtil.drawRect( asdf, FlxG.stage.x, FlxG.stage.y, FlxG.stage.width, FlxG.stage.height, FlxColor.CYAN);// , LineStyle, FillStyle, DrawStyle);
		//FlxNapeState.get_debug().drawAABB(FlxNapeState.space.world.bounds, FlxColor.BLACK);
	}
	
	public function MouseOnClick():Void
	{
		trace("FlxG.camera.zoom = "+FlxG.camera.zoom+"  FlxG.stage.scaleX = "+FlxG.stage.scaleX+"  FlxG.stage.scaleY = "+FlxG.stage.scaleY);
		trace("FlxG.mouse.x = " + FlxG.mouse.x+"   FlxG.mouse.y = " + FlxG.mouse.y);
		trace("FlxG.mouse.getWorldPosition() =" + FlxG.mouse.getWorldPosition().toString());
		trace("");
		trace("FlxG.mouse.screenX = " + FlxG.mouse.screenX+"   FlxG.mouse.screenY = " + FlxG.mouse.screenY);
		trace("FlxG.mouse.getScreenPosition() =" + FlxG.mouse.getScreenPosition().toString());
		trace("");
		trace("kamikaze.x = " + kamikaze.x + "  kamikaze.y = " + kamikaze.y);
		trace("kamikaze.getScreenXY().x = " + kamikaze.getScreenXY().x + "  kamikaze.getScreenXY().y = " + kamikaze.getScreenXY().y);
		
		
		//trace("mouse.getScreenPosition = " + FlxG.mouse.getScreenPosition().toString());
		//trace("mouse.getWorldPosition = " + FlxG.mouse.getWorldPosition().toString());
		//trace("FlxNapeState.space.world.position = " + FlxNapeState.space.world.position.toString());
		//trace("FlxG.camera.buffer.rect = "+FlxG.camera.buffer.rect.toString());
		//trace("DiffX = " + (FlxG.mouse.getScreenPosition().x - FlxG.mouse.getWorldPosition().x));
		//trace("DiffY = " + (FlxG.mouse.getScreenPosition().y - FlxG.mouse.getWorldPosition().y));
		//trace("Diff = " + (FlxG.mouse.getScreenPosition() - FlxG.mouse.getWorldPosition()));
		//trace("FlxNapeState.space.world.toString() = "+FlxNapeState.space.world.translateShapes();
		trace("");
		trace("");
	}
	
	public function ZoomWheel():Void
	{
		/* FlxG.camera.zoom  ||  FlxG.camera.x   ||   FlxG.camera.y
			*      3            ||      -3840       ||      -2880
			*      2.75         ||      -3360       ||      -2400
			*      2.5          ||      -2880       ||      -1920
			*      2.25         ||      -2400       ||      -1440
			*      2.0          ||      -1920       ||      -960
			*      1.75         ||      -1440       ||      -480
			*      1.5          ||       -960       ||         0
			*      1.25         ||       -480       ||       480
			*      1.0          ||          0       ||       960
			* */
		
		var deltaZoom = 0.25;
		deltaZoom *= (FlxG.mouse.wheel > 0) ? 1.0 : -1.0;
		//zoomCamera.targetZoom += deltaZoom;
		FlxG.camera.zoom += deltaZoom;

		trace("FlxG.camera.zoom = " + FlxG.camera.zoom);
	}
	
	public function MoveCamera(delta:Int):Void
	{
		var moving:Bool = false;
		if (FlxG.keys.justReleased.LEFT)
		{
			FlxG.camera.x += delta;
			//FlxG.camera.screen.setPosition(FlxG.camera.screen.x + delta, FlxG.camera.screen.y);
			moving = true;
		}
		
		if (FlxG.keys.justReleased.RIGHT)
		{
			FlxG.camera.x-=delta;
			moving = true;
		}
		
		if (FlxG.keys.justReleased.UP)
		{
			FlxG.camera.y+=delta;
			moving = true;
		}
		
		if (FlxG.keys.justReleased.DOWN)
		{
			FlxG.camera.y -= delta;
			moving = true;
		}

		if (moving)
		{
			trace("FlxG.camera.x = " + FlxG.camera.x + "  FlxG.camera.y = " + FlxG.camera.y);
		}
	}
}
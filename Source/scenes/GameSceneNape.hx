package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.Mask;
import com.haxepunk.nape.NapeScene;
import com.haxepunk.Scene;
import com.haxepunk.Tween.TweenType;
import flash.geom.Point;
import flash.display.BitmapData;
import nape.phys.BodyIterator;
import nape.phys.BodyList;
import nape.phys.Material;

import nape.geom.Vec2;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;
import nape.shape.Polygon;
import nape.phys.Body;
import nape.phys.BodyType;

import openfl.Assets;

import com.haxepunk.tmx.*;
import entities.*;
import GC;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxObject;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;


/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class GameSceneNape extends NapeScene
{
	private var levels : Array<String>;
	
	private var currentLvl : Int;
	private var pausedGame : Bool = false;
	private var pausedEntity : Entity;

	public override function new()
	{
		super();
		HXP.screen.scale = 0.5;//2;//
		HXP.screen.color = 0x000000;

		levels = ["level_00"/*,"level_01","level_02"*/,"level_test"]; // 0,1,2,3
		
		#if debug
		 currentLvl = levels.length - 1;// si es modo Debug, cargo el level_test, es decir el ultimo
		#else
		 currentLvl = 0;
		#end
		
		setupSpaceNape();
		loadLevel();
	
	}
	
	private function setupSpaceNape():Void
	{
		//trace("Seguir testeando NAPE !!!");
		//this.space.clear();// vaciar el Space de Nape, se supone que borra todos los bodies
		this.space = new Space();// creando el mundo de la simulacion con Nape
		this.space.gravity = new Vec2(0, 981);// HXP.screen.height);// valor de gravedad en la simulacion
		
		debugDraw = true;
	}
	
	private function loadLevel()
	{
		removeAll();// borro todo lo que haya en la escena que estaba
		HXP.world.removeAll();

		// agrego una imagen de fondo
		//addGraphic(new Image("gfx/tnt.png"));
		
		// configuro lo que se va a mostrar en la pausa del juego
		var txtPaused = new Text("PAUSED GAME", 0, 0, 200, 50, { size:50, color:0 } );
		//txtPaused.x = 0;
		//txtPaused.y = 0;
		pausedEntity = addGraphic(txtPaused, 0, HXP.halfWidth / 2 - txtPaused.width / 2, HXP.halfHeight - txtPaused.height / 2);
		pausedEntity.set_x(-50);
		pausedEntity.set_y(-50);
		pausedEntity.set_name("pausedEntity");
		pausedEntity.layer = 0;
		pausedEntity.visible = false;
		
		//--* Cargando el nivel hecho con Tiled
		// carga del archivo mapa tmx
		var mapEntity : TmxEntity = new TmxEntity( "maps/" + levels[currentLvl] + ".tmx" );
		//var mapEntity : TmxEntity = new TmxEntity( "maps/level_00.tmx" );
		var mapTmx : TmxMap = TmxMap.loadFromFile( "maps/" + levels[currentLvl] + ".tmx" );
		//var mapTmx : TmxMap = TmxMap.loadFromFile( "maps/level_00.tmx" );
		
		
		// mapa de entidades
		//var mapEntity = new TmxEntity(mapTmx);
		// cargamos la capa del nivel que se va a dibujar
		mapEntity.loadGraphic(GC.IMG_tileset, ["layer_render"]);
		// cargamos la capa con la que colisionaran los objetos
		mapEntity.loadMask("layer_collision", "solid");
		mapEntity.set_name("mapEntity");
		// agregamos la entidad del mapa
		add(mapEntity);

		// recorremos los objetos del mapa del nivel, creandolos y agregandolos
		for (object in mapTmx.getObjectGroup("objects").objects)
		{
		 switch(object.type)
			{// NO llevan 'break;' al final de cada 'case' 
				// leer si la propiedad tipo es player o totem,etc
				
	   case "kamikaze":
					//add(new Kamikaze(object)); 
					//add(new KamikazeActuate(object));
					//add(new KamikazeMO2D(object));
					add(new KamikazeNapeMO2D(object, space));
					
				
			 case "floor":
					LoadFloor(object);
					//add(new Tank(object));
				/*
				case "mummy":
					add(new Mummy(object));
					
				case "mummy generator":
					add(new MummyGenerator(object));
					
				case "tnt":
					add(new Tnt(object));
					
				case "exit": //aqui debo setear la salida del player cuando termina el nivel
					add(new ExitLevel(object));
					*/
				case "text":	//todavia no hago nada con el texto que tengo en el nivel de tiled
					
				/*	
				case "otro_objeto":
					add(new OtroObjeto());
				*/

				default:					//trace("Objeto desconocido: "+object.type);
			}
		}
		
		
	}
	
	private function LoadFloor(obj:TmxObject):Void
	{
		//<object type="floor" x="0" y="928" width="1920" height="32"/>
		//trace("width = " + obj.width + "  height = " + obj.height + "  x = " + obj.x + "  y = " + obj.y);

		// Create the floor for the simulation.
		//   We use a STATIC type object, and give it a single
		//   Polygon with vertices defined by Polygon.rect utility
		//   whose arguments are (x, y) of top-left corner and the
		//   width and height.
		//
		//   A static object does not rotate, so we don't need to
		//   care that the origin of the Body (0, 0) is not in the
		//   centre of the Body's shapes.
		var floor = new Body(BodyType.STATIC);
		// floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
		//floor.shapes.add(new Polygon(Polygon.rect(obj.x, obj.y, obj.width, obj.height, false)));
		floor.shapes.add(new Polygon(Polygon.rect(obj.x, obj.y, obj.width, obj.height, true)));
		floor.space = space;
		floor.setShapeMaterials(new Material(0.5,0.2,0.5,0.24,0.001));
	}
	
	override public function render():Void 
	{
		super.render();
		
	}
	
	override public function update():Void
	{
		super.update();
		
		if (Input.pressed(Key.R))
		{
			space.clear();
			loadLevel();			
		}
		else
		if (Input.pressed(Key.NUMPAD_ADD))
		{
			Zoom(true);
		}
		else
		if (Input.pressed(Key.NUMPAD_SUBTRACT))
		{
			Zoom(false);
		}
		
		
		
	}
	
	public function Zoom(zoom:Bool):Void
	{
		var scale = HXP.screen.scale;
		
		// si me paso de los limites de zoom permitidos
		if ( (scale <= 0.2 && !zoom) || (scale == 0.5 && zoom)	)
			return;
		else
		{
			var deltaScale = 0.05;
			var deltaXY = Std.int(HXP.screen.width/HXP.screen.height)*10;
			//var deltaX = Std.int(HXP.screen.width/HXP.screen.width * scale);
			//var deltaY = Std.int(HXP.screen.height/HXP.screen.height * scale);
			HXP.screen.scale += ((zoom) ? deltaScale : -deltaScale);

			//HXP.screen.x += ((zoom) ? -deltaXY : deltaXY);
			//HXP.screen.y += ((zoom) ? -deltaXY : deltaXY);
			
			//HXP.camera.setTo(HXP.screen.x, HXP.screen.y);
			//HXP.camera.offset(HXP.screen.width, HXP.screen.height);
			
			//HXP.screen.x += ((zoom) ? -deltaX : deltaX);
			//HXP.screen.y += ((zoom) ? -deltaY : deltaY);

			//HXP.camera.x = HXP.screen.x;
			//HXP.camera.y = HXP.screen.y;
			
			HXP.buffer = new BitmapData(HXP.screen.width, HXP.screen.height, true);
			
			//HXP.camera.x = HXP.screen.originX;
			//HXP.camera.y = HXP.screen.originY;
			//HXP.setCamera(HXP.screen.x-250, HXP.screen.y-250);
			
			//HXP.screen.resize();

			trace("scale  " + scale);
			trace("HXP.screen.width  " + HXP.screen.width + "   HXP.screen.height  " + HXP.screen.height);
			trace("HXP.screen.x  "+HXP.screen.x+"   HXP.screen.y  "+HXP.screen.y);
			trace("HXP.camera.toString()  " + HXP.camera.toString());
			//trace("HXP.camera.x  "+HXP.camera.x+"   HXP.camera.y  "+HXP.camera.y);

		}

	}
	
}
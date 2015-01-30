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

import openfl.Assets;

import com.haxepunk.tmx.*;
import entities.*;
import GC;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxObject;


/**
 * ...
 * @author Marcelo Guardia
 */
class GameScene extends Scene
{
	private var levels : Array<String>;
	
	private var currentLvl : Int;
	private var pausedGame : Bool = false;
	private var pausedEntity : Entity;

	public override function begin()
	{
		//HXP.setCamera(0, 500);
		HXP.screen.scale = 0.5;
		HXP.screen.color = 0x000000;

		levels = ["level_00"/*,"level_01","level_02"*/,"level_test"]; // 0,1,2,3
		
		#if debug
		 currentLvl = 1;// si esta compilando en modo Debug, cargo el level_test
		#else
		 currentLvl = 0;
		#end
		
		loadLevel();
	
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
					add(new KamikazeNapeMO2D(object, null));
					
				
			 //case "floor":
					//LoadFloor(object);
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

}
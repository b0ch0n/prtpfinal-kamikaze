package ;

import entities.KamikazeMO2D;
import entities.KamikazeNapeMO2D;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import scenes.GameNapeState;
import nape.shape.Shape;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class TiledLevel extends TiledMap
{
	public var renderTiles:FlxGroup;
	
	public function new(tiledLevel:Dynamic) 
	{
		super(tiledLevel);
		
		renderTiles = new FlxGroup();
		//trace("fullWidth  = "+fullWidth+"  fullHeight  = "+ fullHeight);
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		// Cargando los Tile Maps de cada layer
		LoadTileMapsLayers();
		
	}
	
	public function LoadTileMapsLayers():Void
	{
		for (tileLayer in layers)
		{
			// obtengo el la propiedad tileset en la capa actual
			var tilesetName:String = tileLayer.properties.get("tileset");
			
			//trace("tilesetName = "+tilesetName);
			// si no existe la propiedad, aviso
			if (tilesetName == null)
				throw "Propiedad 'tileset' no definida para la capa '" + tileLayer.name +". Por favor agregue la propiedad a la capa.";
				
			// busco en los tilesets el que corresponde a la capa
			var tiledTileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tilesetName)
				{
					tiledTileSet = ts;
					break;
				}
			}
			
			//trace("tiledTileSet = "+tiledTileSet.numTiles);
			// si el tileset no existe, aviso
			if (tiledTileSet == null)
				throw "El TiledTileSet '"+tilesetName+"' no funciona. Agrego usted la propiedad 'tileset' en la capa '" + tileLayer.name+"' ?";
			
			var tilesetPath = new Path(tiledTileSet.imageSource);
			var fullPath:String = "gfx/" + tilesetPath.file + "." + tilesetPath.ext;
			//trace("fullPath = " + fullPath);
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, fullPath, tiledTileSet.tileWidth, tiledTileSet.tileHeight,0,1,1);
			
			
			
			
			if (tileLayer.name == "layer_render")
			{
				//trace(tileLayer.tileArray.toString());
				renderTiles.add(tilemap);
			}
			
		}
	}
	
	public function LoadObjects(state:GameNapeState):Void
	{
		for (group in objectGroups)
		{
			for (obj in group.objects)
			{
				LoadObject(obj, group , state);
				//trace("obj.gid = "+obj.gid+"   obj.x = "+obj.x+"   obj.y"+obj.y);
			}
		}
	}
	
	public function LoadObject(obj:TiledObject, group:TiledObjectGroup, state:FlxNapeState):Void
	{
		var x:Int = obj.x;
		var y:Int = obj.y;
		
		// los objetos en tiled estan alineados abajo a la izquierda
		// en flixel estan arriba a la izquierda
		if (obj.gid != -1)
			y -= group.map.getGidOwner(obj.gid).tileHeight;
		
		// obtengo cada nombre de los objetos para crearlos y agregarlos
		switch(obj.type.toLowerCase())
		{
			case "kamikaze":
				//trace(FlxNapeState.space);
				//state.add(new KamikazeNapeMO2D(obj, FlxNapeState.space));
				state.add(new KamikazeMO2D(obj, FlxNapeState.space));
			
			case "floor":
				LoadFloor(obj);// , state);
				
			default://nada
		}
		
	}
	
	public function LoadFloor(obj:TiledObject):Void//, state:GameNapeState):Void
	{
		var floor = new Body(BodyType.STATIC);
		floor.shapes.add(new Polygon(Polygon.rect(obj.x, obj.y, obj.width, obj.height, true)));
		//floor.shapes.add(new Polygon(Polygon.rect(200, 200, 400, 400, true)));
		floor.space = FlxNapeState.space;
		floor.setShapeMaterials(new Material(0.5, 0.2, 0.5, 0.24, 0.001));
		floor.debugDraw = true;
	}
	
}
package ;
import flash.display.Bitmap;
import flash.geom.Point;

enum Direction
{
	DOWN; LEFT; RIGHT; UP;
}

/**
 * ...
 * @author ... Marcelo Ruben Guardia
 */
class GC
{
	public static var TILE_H:Float = 32.0;	
	public static var TILE_W:Float = 32.0;
	public static var G:Float = 9.81;

	// tileset
	public static var IMG_tileset:Dynamic = "gfx/tileset.png";	

	// sprites
	public static var IMG_kamikaze:Dynamic = "gfx/kamikaze.png";
	public static var IMG_red_point:Dynamic = "gfx/red-point.png";
	public static var IMG_green_point:Dynamic = "gfx/green-point.png";
	public static var IMG_red_point_32:Dynamic = "gfx/red-point-32.png";
	public static var IMG_green_point_16:Dynamic = "gfx/green-point-16.png";
	public static var IMG_blue_point:Dynamic = "gfx/blue-point.png";
	public static var IMG_breakable_1:Dynamic = "gfx/box/rompible1.png";
	public static var IMG_breakable_2:Dynamic = "gfx/box/rompible2.png";
	public static var IMG_breakable_3:Dynamic = "gfx/box/rompible3.png";
	public static var IMG_breakable_4:Dynamic = "gfx/box/rompible4.png";
	public static var IMG_breakable_5:Dynamic = "gfx/box/rompible5.png";
	public static var IMG_breakable_6:Dynamic = "gfx/box/rompible6.png";
	
	// sprites para renombrar
	public static var IMG_tnt:Dynamic = "gfx/tnt.png";
	public static var IMG_helicoptero:Dynamic = "gfx/helicoptero.png";
	public static var IMG_tanque:Dynamic = "gfx/tanque.png";
	
	
	// sonidos
	public static var SND_boom:Dynamic = "audio/boom.mp3";
	public static var SND_explosion:Dynamic = "audio/explosion.mp3";
	public static var SND_helicopter_shoot:Dynamic = "audio/helicopter_shoot.mp3";
	public static var SND_helicopter:Dynamic = "audio/helicopter.mp3";
	public static var SND_tank_jump:Dynamic = "audio/tank_jump.mp3";
	public static var SND_tank_shoot:Dynamic = "audio/tank_shoot.mp3";
	public static var SND_tank_turn:Dynamic = "audio/tank_turn.mp3";
	public static var SND_tank_walk:Dynamic = "audio/tank_walk.mp3";
	public static var SND_banzai_01:Dynamic = "audio/banzai-01.mp3";
	public static var SND_banzai_02:Dynamic = "audio/banzai-02.mp3";
	
	
	static public function GetRadian(angle:Float):Float
	{
		return ((180 - angle) * Math.PI / 180);
	}
	
	static public function GetDegrees(angle:Float):Float
	{
		return (((angle * 180) / Math.PI) + 180);
	}
}
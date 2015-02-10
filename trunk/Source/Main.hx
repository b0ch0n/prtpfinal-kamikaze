package;


import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import scenes.GameNapeFlxZoomCamera;
import scenes.GameNapeState;
//import scenes.GameState;
import flixel.system.frontEnds.DebuggerFrontEnd;

class Main extends Sprite {	
	
	override public function new () {
		
		super ();
		
		var factor = 6;
		addChild(new FlxGame( 640*factor, 480*factor,null, 3.0, 60, 60, false, true));//4480, 3360));//640, 480));////  , GameNapeState, 0.5));
		//addChild(new FlxGame(640, 480));// 3840, 2880));
				
		//FlxG.camera.zoom = 3.0;
		//if (FlxG.fullscreen)
			//FlxG.camera.zoom = 9.0;
		
		#if debug
			FlxG.debugger.visible = false;
			FlxG.debugger.drawDebug = true;
			FlxG.debugger.toggleKeys = ["ESCAPE", "SPACE"];
			FlxG.switchState(new GameNapeState());
			//FlxG.switchState(new GameNapeFlxZoomCamera());
		#else
			//FlxG.switchState(new MainState());
			FlxG.switchState(new GameNapeState());
		#end		
		
	}	
	
}
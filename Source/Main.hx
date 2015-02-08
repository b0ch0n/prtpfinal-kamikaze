package;


import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import scenes.GameNapeState;
//import scenes.GameState;
import flixel.system.frontEnds.DebuggerFrontEnd;

class Main extends Sprite {	
	
	override public function new () {
		
		super ();
		
		addChild(new FlxGame( 3840, 2880));//4480, 3360));//640, 480));////  , GameNapeState, 0.5));
		
		#if debug
			FlxG.debugger.visible = true;
			FlxG.debugger.drawDebug = true;
			FlxG.debugger.toggleKeys = ["ESCAPE", "SPACE"];
			FlxG.switchState(new GameNapeState());
		#else
			//FlxG.switchState(new MainState());
			FlxG.switchState(new GameNapeState());
		#end		
		
	}	
	
}
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
		
		addChild(new FlxGame( 3840, 2880));// , GameNapeState, 0.5));
		
		#if debug
			FlxG.debugger.visible = true;
			FlxG.debugger.drawDebug = true;
			FlxG.debugger.toggleKeys = ["ESCAPE", "SPACE"];
			//FlxG.switchState(new GameState());
			FlxG.switchState(new GameNapeState());
		#end		
		
	}	
	
}
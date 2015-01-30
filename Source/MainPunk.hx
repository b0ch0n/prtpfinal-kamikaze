import com.haxepunk.Engine;
import com.haxepunk.HXP;
import scenes.GameScene;
import com.haxepunk.utils.Key;
import scenes.GameSceneNape;

import com.haxepunk.debug.Console;

class Main extends Engine
{

	override public function init()
	{
		#if debug
				HXP.width = 640;// 1280;
				HXP.height = 480;// 960;
				HXP.console.enable(TraceCapture.No);
				HXP.console.toggleKey = Key.ESCAPE;
				//HXP.scene = new scenes.GameScene();
				HXP.scene = new scenes.GameSceneNape();
		#else
				HXP.scene = new scenes.MainScene();
		#end
	}

	public static function main() { new Main(); }

}
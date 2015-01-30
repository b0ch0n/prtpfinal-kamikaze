package scenes;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author Marcelo Ruben Guardia
 */
class EndScene extends Scene
{
	override public function begin()
	{
		//--*En esta escena principal voy a crear una presentacion y al presionar la tecla space
		//--* empieza el 1er nivel
		
		// agrego una imagen de fondo
		addGraphic(new Image("gfx/bg.png"));
		
		// configuro el texto de la pantalla que quiero agregar
		var presentacion = new String("Marcelo Rubén Guardia\nPrototipado Rápido\nTrabajo Práctico Número 2\n\n"
		+"\nLograste pasar de nivel!");
		var pressStart = new String("Presione \"Space\" para ir al Menu Inicial");
		
		#if flash //si es para plataforma flash
			var txtOptions  = { color:0x1ECE15, size:25, align: TextFormatAlignType.CENTER, font: "font/LinLibertine_R.ttf" };
			var txtOptionsB = { color:0x1ECE15, size:20, align: TextFormatAlignType.CENTER, font: "font/04B_03__.ttf"};
		#else //si es para otra plataforma
			var txtOptions  = { color:0x1ECE15, size:25, align: "center", font: "font/04B_03__.ttf" };
			var txtOptionsB = { color:0x1ECE15, size:20, align: "center", font: "font/04B_03__.ttf"};
		#end //cierro las opciones de plataformas
		
		// creando el texto con las opciones seteadas anteriormente
		var txtPresentacion = new Text(presentacion, txtOptions);
		var txtPressStart = new Text(pressStart, txtOptionsB);
		
		// agrego los textos de la pantalla
		addGraphic(txtPresentacion, 0, HXP.halfWidth - txtPresentacion.width / 2, 30);// HXP.halfHeight - txtPresentacion.height / 2);
		addGraphic(txtPressStart  , 0, HXP.halfWidth - txtPressStart.width/2  , HXP.height - txtPressStart.height);
	}
	
	override public function update()
	{
		// si se presiona la tecla Space, se crea la nueva Scene comenzando el juego
	 if (Input.pressed(Key.SPACE))
		 HXP.scene = new MainScene();
	}

}
package;

import game.states.Startup;
import openfl.display.FPS;
import game.states.PlayState;
import flixel.FlxState;
import flixel.FlxGame;
import openfl.display.Sprite;

typedef FlxGameData = {
	w:Int,
	h:Int,
	initialState:Class<FlxState>,
	updateFramerate:Int,
	drawFramerate:Int,
	skipSplash:Bool,
	fullscreen:Bool,
	?zoom:Float
}

class Main extends Sprite
{
	inline public static final SND_EXT:String = #if web ".mp3" #else ".ogg" #end;

	public static var instance:Main;
	public static var gameData:FlxGameData = 
	{
		w: 0,
		h: 0,
		initialState: PlayState,
		updateFramerate: 60,
		drawFramerate: 60,
		skipSplash: true,
		fullscreen: false,
		zoom: 1
	};

	public var game:FlxGame;
	public var fps:FPS;

	public function new()
	{
		super();
		
		instance = this;

		game = new FlxGame(
			gameData.w, gameData.h, #if ("flixel" < "5.0.0") gameData.zoom, #end Startup, 
			gameData.updateFramerate, gameData.drawFramerate, gameData.skipSplash, gameData.fullscreen
		);

		addChild(game);

		fps = new FPS(5, 5, 0xFFFFFFFF);
		#if debug
		fps.showMemory = true;
		#end
		addChild(fps);
	}
}

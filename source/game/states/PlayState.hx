package game.states;

import flixel.math.FlxPoint;
import flixel.FlxCamera;
import game.states.substate.PauseSubstate;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import game.objects.Section;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import game.objects.Obstacle;
import game.objects.Player;
import flixel.FlxState;

typedef Level = {
	sections:Array<Section>
}

/*
typedef LevelObstacle = {
	x:Float,
	y:Float,
	id:Int
}
*/

class PlayState extends FlxState
{
	public static var instance:PlayState;

	//var level:Level;

	public var gameCam:FlxCamera;
	public var hudCam:FlxCamera;

	var playerPos:FlxObject;
	public var player:Player;

	// Collidables
	var terrain:FlxSprite;
	var sections:Array<Section> = [];

	var prevModifier:Int = 0;

	override public function create()
	{
		instance = this;
		super.create();

		gameCam = new FlxCamera();
		hudCam = new FlxCamera();
		gameCam.bgColor.alpha = 0;
		hudCam.bgColor.alpha = 0;

		FlxG.cameras.reset(gameCam);
		FlxG.cameras.add(hudCam, false);

		FlxG.cameras.setDefaultDrawTarget(gameCam, true);

		playerPos = new FlxObject(0, 0, 1, 1);
		playerPos.screenCenter(Y);
		add(playerPos);

		player = new Player(1,1);
		add(player);

		createLevel();

		FlxG.camera.follow(playerPos, LOCKON, 1);

		//FlxG.came	ra.minScrollY = 0;
		//FlxG.camera.maxScrollY = 0;

		//FlxG.camera.zoom = 0.9;
	}

	override public function update(elapsed:Float)
	{
		//trace("Frame 0 " + '${FlxG.camera.scroll.x}:${FlxG.camera.scroll.y}');

		super.update(elapsed);

		playerPos.x = player.x;
		//FlxMath.lerp(FlxG.camera.followLerp, 1, 0.035);
		//player.acceleration.x += 1;

		FlxG.collide(player, terrain);
		for (section in sections)
		{
			FlxG.collide(player, section.terrain);
			for (obstacle in section.obstacles)
			{
				FlxG.collide(player, obstacle, onDeath);
			}
		}

		if (FlxG.keys.anyJustPressed([ESCAPE, ENTER, P]))
			super.openSubState(new PauseSubstate());
		
	}

	function onDeath(a, b):Void
	{
		var fakePlayer:FlxSprite = player.clone();
		fakePlayer.setPosition(player.x, player.y);
		fakePlayer.color = FlxColor.GRAY;
		fakePlayer.active = false;
		add(fakePlayer);

		player.x = FlxG.width / 2;
		player.stop();

		FlxG.camera.follow(null);

		// Time to do something CRAZY!!! he he he ....
		restoreModifier();
		prevModifier = FlxG.random.int(1, 2);
		trace("Modifier pussy! " + prevModifier);

		switch (prevModifier)
		{
			case 1:
				FlxG.camera.angle = 180;

			case 2:
				// Invert
				for (section in sections)
					section.x = -section.x;

				player.inverted = true;
		}

		FlxTween.tween(FlxG.camera, {"scroll.x": 0}, 0.25, {ease: FlxEase.quadInOut, onComplete: (t:FlxTween) -> 
		{
			FlxG.camera.follow(playerPos, LOCKON, 1);
			player.moveX();
		}});
	}

	function restoreModifier():Void
	{
		switch (prevModifier)
		{
			case 1:
				FlxG.camera.angle = 0;

			case 2:
				for (section in sections)
					section.x = -section.x;

				player.inverted = false;
		}
	}

	function createLevel():Void
	{
		// GENERATE LEVEL
		var newLevel:Level = {
			sections: []
		};

		var diff:Float = Save.data.levelsPassed / 10;
		var minDistanceBetween:Int = 225;
		var levelSize:Int = 25; // HOW MANY SECTIONS

		var fiends:Array<Obstacle> = []; // Optimisations

		for (i in 0...levelSize) {
			var section = new Section(1280 + (1280 * i), 0, i);
			var numObs:Int = FlxG.random.int(3, 7);

			for (j in 0...numObs)
			{	
				var obs = new Obstacle(0, 0, FlxG.random.int(0, 3));
				
				var bad:Bool = false;
				/*
				// Previous sections exist
				if (i > 0)
				{
					// Get previous section
					var prevSec = sections[i - 1];
					if (prevSec != null)
					{
						// Get last obstacle
						var lastObs = prevSec.obstacles[prevSec.obstacles.length - 1];

						// Prevent being close to each other as two sections meet
						if (lastObs != null && lastObs.x + minDistanceBetween > 1280) 
							obs.x = (1280 - lastObs.x) + minDistanceBetween - 30;
						else // Enough far away
						{
							obs.x = lastObs.x + (minDistanceBetween + 75) + FlxG.random.int(-50, 50);
						}
					}
				}
				else // First section ever
				{
					var lastObs = section.obstacles[section.obstacles.length - 1];
					if (lastObs != null)
						obs.x = lastObs.x + (minDistanceBetween + 75) + FlxG.random.int(-50, 50);
					else // First obstacle ever
						obs.x = FlxG.random.int(0, minDistanceBetween);
				}

				obs.y = section.terrain.y - obs.height;
				*/

				obs.relativeX = obs.x = j * (minDistanceBetween + 85) + FlxG.random.int(-50, 50);
				if (obs.x > 1280)
					continue;

				obs.y = section.terrain.y - obs.height;

				var prevSection = sections[sections.length - 1];
				if (prevSection != null)
				{
					var lastObst = prevSection.obstacles[prevSection.obstacles.length - 1];
					if (lastObst != null)
					{
						if (lastObst.relativeX >= (1280 - lastObst.width))
						{
							//lastObst.kill();
							//prevSection.obstacles.remove(lastObst);
							//prevSection.remove(lastObst, true);
							obs.kill();
							fiends.push(obs);
							bad = true;
							//lastObst.destroy();
						}

						if (FlxMath.distanceBetween(lastObst, obs) < minDistanceBetween)
						{
							obs.kill();
							fiends.push(obs);
							bad = true;
	
							continue; // Don't add new obs
						}
					}
				}

				if (!bad)
				{
					section.add(obs);
					section.obstacles.push(obs);
				}	
			}

			add(section);
			sections.push(section);
		}
		
		for (fiend in fiends)
		{
			fiends.remove(fiend);
			fiend.destroy();
		}

		FlxG.worldBounds.set(FlxG.width + FlxG.width * levelSize, FlxG.height);

		player.screenCenter();

		terrain = new FlxSprite(0,0);
		terrain.makeGraphic(FlxG.width, 48, FlxColor.LIME);
		terrain.y = FlxG.height - 32;
		terrain.immovable = true;
		//terrain.allowCollisions = UP;
		add(terrain);

		//level = newLevel;
	}
}

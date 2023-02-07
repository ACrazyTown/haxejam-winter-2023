package game.states;

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

	var playerPos:FlxObject;
	public var player:Player;

	// Collidables
	var terrain:FlxSprite;
	var sections:Array<Section> = [];

	override public function create()
	{
		instance = this;
		super.create();

		playerPos = new FlxObject(0, 0, 1, 1);
		playerPos.screenCenter(Y);
		add(playerPos);

		player = new Player(1,1);
		add(player);

		createLevel();

		FlxG.camera.follow(playerPos, LOCKON, 1);

		//FlxG.camera.minScrollY = 0;
		//FlxG.camera.maxScrollY = 0;

		//FlxG.camera.zoom = 0.9;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		playerPos.x = player.x;
		//FlxMath.lerp(FlxG.camera.followLerp, 1, 0.035);

		FlxG.collide(player, terrain);
		for (section in sections)
		{
			FlxG.collide(player, section.terrain);
			for (obstacle in section.obstacles)
			{
				FlxG.collide(player, obstacle, onDeath);
			}
		}
		
	}

	function onDeath(a, b):Void
	{
		//var fakePlayer:FlxSprite = player.clone();
		//fakePlayer.setPosition(player.x, player.y);

		player.x = FlxG.width / 2;
		//FlxG.camera.follow(null);

		//FlxTween.tween(FlxG.camera, {"scroll.x": FlxG.width / 2}, 0.3, {ease: FlxEase.quadInOut, onComplete: (t:FlxTween) -> 
		//{
		//	FlxG.camera.follow(playerPos, LOCKON, 1);
		//}});

		trace("dead ");
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

		for (i in 0...levelSize) {
			var section = new Section(1280 + (1280 * i), 0, i);
			var numObs:Int = FlxG.random.int(2, 10);

			for (j in 0...numObs)
			{	
				var obs = new Obstacle(0, 0, FlxG.random.int(0, 3));
				
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
							obs.x = (j * (minDistanceBetween + 75)) + FlxG.random.int(-50, 50);
						}
					}
				}
				else // First section ever
				{
					obs.x = (j * (minDistanceBetween + 75)) + FlxG.random.int(-50, 50);
				}

				obs.y = section.terrain.y - obs.height;

				section.add(obs);
				section.obstacles.push(obs);
			}

			add(section);
			sections.push(section);
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

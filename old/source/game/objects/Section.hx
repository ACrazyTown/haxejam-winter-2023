package game.objects;

import game.states.PlayState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class Section extends FlxSpriteGroup
{
    public var terrain:FlxSprite;
    public var obstacles:Array<Obstacle> = [];

    public function new(x:Float = 0, y:Float = 0, id:Int = 0)
    {
        super(x, y);

        var debugTxt:FlxText = new FlxText(0, 0, 0, '$id', 32);
        add(debugTxt);

        terrain = new FlxSprite(0,0);
		terrain.makeGraphic(FlxG.width, 48, FlxColor.LIME);
		terrain.y = FlxG.height - 32;
		terrain.immovable = true;
        //terrain.alpha = 0.1;
        //terrain.offset.set(10, 10);
		add(terrain);
        terrain.updateHitbox();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
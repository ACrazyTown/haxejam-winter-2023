package game.objects;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Obstacle extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, id:Int = 0)
    {
        super(x, y);

        makeGraphic(32, 54, FlxColor.BLUE);
        immovable = true;
    }
}
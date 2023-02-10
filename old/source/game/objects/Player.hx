package game.objects;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite 
{
    public var speed:Int = 270;
    var gravity:Int = 1250;

    public var inverted:Bool = false;
    public var invincible:Bool = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        makeGraphic(48, 48, FlxColor.RED);

        drag.set(speed*8, speed*8);
        acceleration.x = speed;
        acceleration.y = gravity;
        maxVelocity.set(speed, gravity);
    }

    public var canControl:Bool = true;
    override function update(elapsed:Float):Void
    {
        if (canControl && isTouching(FLOOR) && (FlxG.keys.anyPressed([SPACE, W, UP]) || FlxG.mouse.pressed))
            velocity.y = -acceleration.y * 0.475;
        
        super.update(elapsed);
    }

    inline public function stop():Void
        acceleration.x = 0;

    inline public function moveX():Void
        acceleration.x = inverted ? -speed : speed;
}
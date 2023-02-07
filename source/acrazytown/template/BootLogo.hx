package acrazytown.template;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;

class BootLogo extends FlxSprite
{
    public var sound:FlxSound;
    public var onComplete:BootLogo->Void;

    var isPlaying:Bool = false;

    public function new(?onComplete:BootLogo->Void):Void
    {
        super(0, 0); 

        if (onComplete != null)
            this.onComplete = onComplete;

		frames = FlxAtlasFrames.fromSparrow("assets/images/template/bootlogo.png", "assets/images/template/bootlogo.xml");
        animation.addByPrefix("anim", "intro anim", 30, false);

        sound = new FlxSound().loadEmbedded('assets/sounds/template/boot${Main.SND_EXT}');
        FlxG.sound.list.add(sound);

        antialiasing = true; // Always force AA, looks shitty without it
        visible = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

		
        if (animation.curAnim != null)
		{
			FlxG.watch.addQuick("CurFrame", animation.curAnim.curFrame);

			if (isPlaying && sound != null)
				animation.frameIndex = animation.curAnim.frames[Math.floor(sound.time / sound.length * animation.curAnim.numFrames)];

            if (animation.finished)
            {
                if (isPlaying)
                {
                    isPlaying = false;
                    sound.stop();
                }

                if (onComplete != null)
                    onComplete(this);
            }
        }
    }

    override function destroy():Void
    {
        super.destroy();
        sound.destroy();
        onComplete = null;
    }

    public function play(?skip:Bool = false):Void
    {
        if (!skip)
        {
            visible = true;

            animation.play("anim"); // actually play

            setGraphicSize(Std.int(width / 2 * (FlxG.width / width)));
            updateHitbox();
            screenCenter();

            sound.play();
        }
        else
        {
            if (onComplete != null)
                onComplete(this);
        }
    }
}
package game.states.substate;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSubState;

class PauseSubstate extends FlxSubState
{
    var items:Array<String> = [
        "Resume",
        "Regenerate Level",
        "Exit to menu"
    ];
    var itemGroup:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    public function new()
    {
        super();
    
        itemGroup = new FlxTypedGroup<FlxText>();
        add(itemGroup);

        for (i in 0...items.length)
        {
            var text:FlxText = new FlxText(10, 10 + i * 50, 0, items[i], 32);
            text.ID = i;
            text.cameras = [PlayState.instance.hudCam];
            itemGroup.add(text);
        }

        select();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)
            select(-1);
        if (FlxG.keys.justPressed.DOWN)
            select(1);
        if (FlxG.keys.justPressed.ENTER)
            trigger();
    }

    function select(change:Int = 0)
    {
        curSelected += change;

        if (curSelected > items.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = items.length - 1;

        itemGroup.forEach((text:FlxText) -> 
        {
            text.color = FlxColor.WHITE;

            if (text.ID == curSelected)
                text.color = FlxColor.YELLOW;
        });
    }

    function trigger()
    {
        switch (curSelected)
        {
            case 0:
                close();

            case 1:
                FlxG.resetState();

            case 2:
                trace("Unlucky");
        }
    }
}
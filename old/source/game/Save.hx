package game;

import flixel.FlxG;

typedef SaveData = {
    levelsPassed:Int
}

class Save {
    public static var data:SaveData = null;

    public static function load():Void
    {
        data = {
            levelsPassed: 0
        };

        if (FlxG.save.data.saveData != null)
            data = FlxG.save.data.saveData;
        else 
        {
            FlxG.save.data.saveData = data;
            FlxG.save.flush();
        }
    }
}
package;

import flixel.math.FlxMath;
import flixel.FlxG;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FramerateCounter extends TextField
{
    public var currentFPS(default, null):Float;

    @:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

    public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

    @:noCompletion
    private #if !flash override #end function __enterFrame(deltaTime:Float):Void
    {
        currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

        var currentCount = times.length;
        currentFPS = FlxMath.bound(Math.round(currentCount + cacheCount), 0, FlxG.updateFramerate);

        if (currentCount != cacheCount)
            text = "FPS: " + currentFPS;

        cacheCount = currentCount;
    }
}
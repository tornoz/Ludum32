package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class Player extends FlxSprite {

	public var speed:Float = 150;
	
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		
		loadGraphic("assets/images/player.png", true, 32,32);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		//animation.add("u", [3,4,3,5], 6, false);
		//animation.add("lr", [6,7,6,8], 6, false);
		animation.add("i", [4,5,6,7], 4);
		animation.add("d", [0,1,2,3], 6, false);
		animation.add("lri", [8,9,10,11], 4);
		animation.add("lr", [12,13,14,15], 6);
		animation.add("ui", [16,17,18,19], 4);
		animation.add("u", [20,21,22,23], 6, false);
		drag.x = drag.y = 1600;
		

		
		//gibs.makeParticles(Reg.GIBS, 100, 10, true, 0.5);
	}

	
	override public function update():Void {
		
	
		
	    movement();
		super.update();
	}
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		if ( _up || _down || _left || _right)
			{
				var mA:Float = 0;
				if (_up)
					{
						mA = -90;
						if (_left)
							mA -= 45;
						else if (_right)
							mA += 45;
						facing = FlxObject.UP;
					}
				else if (_down)
					{
						mA = 90;
						if (_left)
							mA += 45;
						else if (_right)
							mA -= 45;
						facing = FlxObject.DOWN;
					}
				else if (_left)
					{
						mA = 180;
						facing = FlxObject.LEFT;
					}
				else if (_right)
					{
						mA = 0;
						facing = FlxObject.RIGHT;
					}
				FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
			}
	}

	override public function draw():Void
	{
		if (velocity.x != 0 || velocity.y != 0)	{
				switch(facing)	{
						case FlxObject.LEFT, FlxObject.RIGHT:
							animation.play("lr");
						case FlxObject.UP:
							animation.play("u");
						case FlxObject.DOWN:
							animation.play("d");
				}
		}
		else {
		    switch(facing)	{
						case FlxObject.LEFT, FlxObject.RIGHT:
							animation.play("lri");
						case FlxObject.UP:
							animation.play("ui");
						case FlxObject.DOWN:
							animation.play("i");
				}
			
		}
		super.draw();
	}



}
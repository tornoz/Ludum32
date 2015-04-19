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
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

class Mumy extends TimedSprite {

	var player:Player;
    var angry = false;
    var map:TiledLevel;
    
	private var following:FlxPoint;
    
    
	public function new(X:Int, Y:Int, player:Player, map:TiledLevel){
		super(X, Y);
		this.player = player;
		this.map = map;
		graphPath = "assets/images/mumy.png";
		loadGraphic("assets/images/mumy.png", true, 16,32);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("d", [6,7], 6, false);
		animation.add("lr", [0,1,2,3], 6);
		animation.add("u", [4,5], 6, false);
		
		drag.x = drag.y = 100;
		maxVelocity.set(100, 100);
		//gibs.makeParticles(Reg.GIBS, 100, 10, true, 0.5);
	}

	
	override public function update():Void {
	    if(FlxMath.distanceBetween(this, player) < 120) {
	        if(!angry) {
	             angry = true;
	        }
	    } else {
	         if(angry) {
                 angry = false;
                 this.acceleration.x = 0;
                 this.acceleration.y = 0;
                 this.velocity.x = 0;
                 this.velocity.y = 0;
	        } 
	    }
	    if(angry) {
	        
	        var path = map.tilemap.findPath(
	            FlxPoint.get(x, y),
	            FlxPoint.get(player.x + player.width/2, player.y + player.height/2)
	        );
	        if(path.length > 1) {
				this.setFollow(path[1]);
			}
            if(following.x > this.x && acceleration.x <= 0) {
                acceleration.x += drag.x;
                facing = FlxObject.RIGHT;
            }
            else if(following.x < this.x && acceleration.x >= 0) {
                acceleration.x -= drag.x;
                facing = FlxObject.LEFT;
            }
             if(following.y > this.y && acceleration.y <= 0) {
                acceleration.y += drag.y;
                facing = FlxObject.DOWN;
            }
            else if(following.y < this.y && acceleration.y >= 0) {
                acceleration.y -= drag.y;
                facing = FlxObject.UP;
            }
	    }
	    
	    
		
	    
		super.update();
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
		   if(animation.curAnim != null)
				animation.curAnim.restart();
			animation.pause();
			
		}
		super.draw();
	}
	
	public function setFollow(f:FlxPoint) {
		this.following = f;
		//target.x = f.x;
		//target.y = f.y;
	}
	



}
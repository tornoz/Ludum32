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
import flash.filters.BlurFilter;
import flixel.effects.FlxSpriteFilter;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

class Troll extends TimedSprite {

	var player:Player;
    var angry = false;
    
    public var jumpWait:Float = 0;
	public var jumpTime:Float = 0.1;
	public var jumping = false;
	
	
    
	public function new(X:Int, Y:Int, player:Player){
		super(X, Y);
		this.player = player;
		graphPath = "assets/images/troll.png";
		loadGraphic("assets/images/troll.png", true, 48,48);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("iddle", [0,1,2,1,0,1,2,3], 4);
		animation.add("angry", [4,5],8);
		animation.play("iddle");
		
		drag.x = drag.y = 350;
		maxVelocity.set(200, 200);
		//gibs.makeParticles(Reg.GIBS, 100, 10, true, 0.5);
	}

	
	
	override public function update():Void {
		
	    if(FlxMath.distanceBetween(this, player) < 120) {
	        if(!angry) {
	             angry = true;
	             animation.play("angry");
	        }
	    } else {
	         if(angry) {
                 angry = false;
                 animation.play("iddle");
                 this.acceleration.x = 0;
                 this.acceleration.y = 0;
                 this.velocity.x = 0;
                 this.velocity.y = 0;
	        } 
	    }
	    if(angry) {
	        jump();
	    }
		super.update();
	}

	public function jump():Void {
	    jumpWait += FlxG.elapsed;
		if(jumpWait > jumpTime) {
			jumpWait = 0;
			jumpTime = FlxRandom.floatRanged(0.2,0.4);
			jumping = !jumping;
			if(!jumping) {
				//animation.play("iddle");
				this.acceleration.x = 0;
				this.acceleration.y = 0;
				this.velocity.x = 0;
				this.velocity.y = 0;
			}
			else {
				//animation.play("jump");
			}
				
		}
		if(jumping) {
			if(player.x > this.x && acceleration.x <= 0) {
				acceleration.x += drag.x;
				facing = FlxObject.RIGHT;
			}
			else if(player.x < this.x && acceleration.x >= 0) {
				acceleration.x -= drag.x;
				facing = FlxObject.LEFT;
			}
			if(player.y > this.y && acceleration.y <= 0) {
				acceleration.y += drag.y;
				facing = FlxObject.RIGHT;
			}
			else if(player.y < this.y && acceleration.y >= 0) {
				acceleration.y -= drag.y;
				facing = FlxObject.LEFT;
			}
			velocity.y -= (jumpTime/2 - jumpWait*1.8)*100; 
		}
	}
	
	override public function getGhost() {
	    var ghost = new FlxSprite(this.x, this.y);
	    ghost.loadGraphicFromSprite(this);
	    ghost.alpha = 0.5;
	    ghost.width -=16;
        ghost.height -= 16;
        ghost.centerOffsets();
        ghost.height -= 20;
        ghost.offset.y += 15;
        var blurFilter = new BlurFilter();
		
		var sprFilter  = new FlxSpriteFilter(ghost, 50, 50);
		sprFilter.addFilter(blurFilter);
		
        return ghost;
	}



}
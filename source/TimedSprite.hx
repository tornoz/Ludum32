package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;

import flash.filters.BlurFilter;
import flixel.effects.FlxSpriteFilter;

class TimedSprite extends FlxSprite {

    public static var BUFFER_SIZE = 500; // in seconds
    private var array:Array<FlxPoint>;
    
    private var index = -1;
    private var pos:FlxPoint;
    public var state:FlxState;
    private var ghosts:FlxTypedGroup<FlxSprite>;
    private var ghostCounter:Float = 0.5;
    private var ghostTime:Float = 0.5;
    
    private var graphPath = "";
    private var ghostMap:Map<Int, FlxSprite>;
    
    public var rewinding = false;
    
    public function new(X:Int, Y:Int){
        array = new Array<FlxPoint>();
        ghosts = new FlxTypedGroup<FlxSprite>();
        ghostMap = new Map<Int, FlxSprite>();
        super(X,Y);
    }
    
    public function setState(state:FlxState) {
        this.state = state;
    }
    
    override public function update():Void {
        //trace("update");
        if(rewinding) {
            //trace("rewinding from " + index);
            //trace(array.length);
            if(index > 0) {
                this.x = array[index].x;
                this.y = array[index].y;
                index--;
                ghostCounter += FlxG.elapsed;
                if(ghostCounter >= ghostTime) {
                    ghostCounter = 0;
                    var ghost = this.getGhost();
                    state.add(ghost);
                    ghosts.add(ghost);
                    ghostMap.set(index, ghost);
                }
                
            }
        } else if (index < array.length-1) {
            //trace("forwarding");
            this.x = array[index].x;
            this.y = array[index].y;
            index++;
            if(ghostMap.exists(index)) {
                var ghost = ghostMap.get(index);
                ghostMap.remove(index);
                ghosts.remove(ghost);
                ghost.destroy();
            }
            
        } else {
            //trace("push to " + (index + 1));
            super.update();
            push(new FlxPoint(this.x, this.y));
        }
       
    }
    
    public function push(x:FlxPoint):Void {
        array.push(x);
        if (array.length -1 > BUFFER_SIZE) {
            array.shift();
        }
        if(index < BUFFER_SIZE) {
            index++;
        }
        
    }
    
    public function getGhost() {
        var ghost = new FlxSprite(this.x, this.y);
	    ghost.loadGraphicFromSprite(this);
	    ghost.alpha = 0.5;
	    
		var blurFilter = new BlurFilter();
		
		var sprFilter  = new FlxSpriteFilter(ghost, 50, 50);
		sprFilter.addFilter(blurFilter);
        return ghost;
    }
    
    public function stopRewinding() {
        rewinding = false;
    }
    
    
    
    public function startRewinding() {
        rewinding = true;
        ghostCounter = 0.5;
    }
    
    
}
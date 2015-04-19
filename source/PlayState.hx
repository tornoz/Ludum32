package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    
    private var map:TiledLevel;
    private var player:Player;
    private var objects:FlxTypedGroup<TimedSprite>;
	private var bar:FlxSprite;
	private var ld:FlxSprite;
	
	private var rewindTime:Float = 4;
	private var timeLeft:Float = 4;
    /**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
	    FlxG.mouse.visible = false;
	    trace(Reg.level);
	    map = new TiledLevel("assets/data/" + Reg.levels[Reg.level] + ".tmx");
	    add(map.tilemap);
		
		
		map.loadObjects(this);
		objects = map.objects;
		player = map.player;
		ld = map.ld;
		FlxG.camera.follow( player, flixel.FlxCamera.STYLE_TOPDOWN );
		FlxG.camera.setBounds(0, 0, map.width*16, map.height*16);
		FlxG.worldBounds.copyFrom(map.tilemap.getBounds());

		FlxG.camera.bgColor = 0;
		for(obj in objects) {
		     TimeManager.getInstance().array.push(obj);   
		}
		var barUi = new FlxSprite(-6,-2);
		barUi.loadGraphic("assets/images/bar.png", true, 128, 32);
		barUi.scrollFactor.x = barUi.scrollFactor.y = 0;
		
		bar = new FlxSprite(10,10);
		bar.makeGraphic(96,8,FlxColor.BLUE, true);
		bar.scrollFactor.x = bar.scrollFactor.y = 0;
		bar.origin.set(0,0);
		add(bar);
		add(barUi);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
	    map.collideWithLevel(player);
	    map.collideWithLevel(objects);
	    FlxG.collide(player, ld, win);
	    customOverlap(player, objects);
	    //FlxG.overlap(player,objects, hit);
	    if (FlxG.keys.anyJustPressed(["X"])) {
	        TimeManager.getInstance().startRewind();
	        
	    } else if (FlxG.keys.anyJustReleased(["X"])) {
	        TimeManager.getInstance().stopRewind();
	    } 
	    if(FlxG.keys.anyPressed(["X"])) {
	        
	        if(timeLeft <= 0) {
	            TimeManager.getInstance().stopRewind();
	        } else {
	            timeLeft -= FlxG.elapsed;
	        }
	    } else if(timeLeft < rewindTime)  {
	         timeLeft += FlxG.elapsed;   
	    }
	    bar.setGraphicSize(Std.int(Math.max(1, timeLeft * (96 / rewindTime))), 8); 
	    
		super.update();
	}	
	
	public function customOverlap(player:FlxSprite, enemies:FlxTypedGroup<TimedSprite>) {
	    for(enemy in enemies) {
	        if (player.x < (enemy.x + enemy.width) && 
	            player.x + player.width > enemy.x &&
	            player.y < (enemy.y + enemy.height)  && 
	            player.y + player.height > enemy.y) 
	            {
	              hit(player, enemy);
	            }
	    }
	}
	
	public function hit(player:Dynamic, enemy:Dynamic ):Void {
	    openSubState( new LostState());
	}
	
	public function win(player:Dynamic, ld:Dynamic ):Void {
	    Reg.level = (Reg.level + 1)%3;
	    FlxG.resetState();
	}
}
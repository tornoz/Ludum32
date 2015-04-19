package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class LostState extends FlxSubState {

	private var title:FlxSprite;
	
	public override function create() {
		title = new FlxSprite(0,0);
		FlxG.mouse.visible = true;
		
		title.loadGraphic("assets/images/lost.png");
		title.scrollFactor.x = title.scrollFactor.y = 0;
		add(title);
		
		super.create();
	}
	
	
		
	public override function update() {
		if (FlxG.keys.anyPressed(["SPACE", "ENTER"])) {
			FlxG.resetState();
		}
		
		super.update();
	}

}
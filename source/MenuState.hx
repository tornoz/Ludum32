
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
        /**
         * Function that is called up when to state is created to set it up.
         */
        override public function create():Void
        {
			var title:FlxSprite  = new FlxSprite(0,0);
			title.loadGraphic("assets/images/title.png",false, 341,256);
			add(title);
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
			if (FlxG.keys.justPressed.ENTER) {
				FlxG.switchState(new PlayState());
			}
                super.update();
        }
}


package;

import flixel.FlxG;
import flixel.system.FlxSound;
class TimeManager {

    public var array:Array<TimedSprite>;
    private var timeSound:FlxSound;

    private static var instance:TimeManager = null;
    private var rewinding = false;
    private function new(){
        array = new Array<TimedSprite>();
        timeSound = FlxG.sound.load("assets/sounds/timetravel.wav",1, true);
    }
    
    public static function getInstance():TimeManager {
        if(instance == null) {
            instance = new TimeManager();
        }
        return instance;
    }
    
    public function startRewind() {
        FlxG.camera.shake(0.01, 0.1, shakeComplete);
        //FlxG.sound.play("assets/sounds/timetravel.mp3",1, true);

        timeSound.play();
        rewinding = true;
        for(sprite in array) {
            sprite.startRewinding();
        }
    }
    
    public function stopRewind() {
        rewinding = false;
        timeSound.stop();
        for(sprite in array) {
            sprite.stopRewinding();  
        }
    }
    
    public function shakeComplete() {
        if(rewinding) {
            FlxG.camera.shake(0.01, 0.1, shakeComplete);
        }
    }
    
}
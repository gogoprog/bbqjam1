package game;

import js.Lib;
import js.jquery.*;
import js.Browser.document;
import js.Browser.window;
import phaser.Game;
import phaser.Phaser;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import whiplash.*;
import whiplash.math.*;
import whiplash.phaser.*;
import whiplash.common.components.Active;

class Game extends Application {
    static public var instance:Game;

    public function new() {
        var config = {
            render:{
                transparent:false,
                pixelArt:true
            },
            scale : {
                mode: phaser.scale.scalemodes.NONE
            },
            backgroundColor:"#00BFFF"
        };
        super(Config.screenWidth, Config.screenHeight, ".root", config);
        instance = this;
    }

    override function preload():Void {
        super.preload();
        Factory.preload(whiplash.Lib.phaserScene);
    }

    override function create():Void {
        var game = whiplash.Lib.phaserGame;
        game.sound.pauseOnBlur = false;
        AudioManager.init(whiplash.Lib.phaserScene);
        Factory.init(whiplash.Lib.phaserScene);

        whiplash.platformer.Lib.init(this);

        var e = Factory.createObjectHandler();
        engine.addEntity(e);

        var e = Factory.createLevel(0, false, 0);
        engine.addEntity(e);
        var e = Factory.createLevel(1, true, 5);
        engine.addEntity(e);
        var e = Factory.createLevel(2, false, 10);
        engine.addEntity(e);

        var e = Factory.createCamera();
        engine.addEntity(e);

        var menu = Factory.createLevel(2, false, 100);
        // engine.addEntity(menu);

        var menuState = createState("menu");
        menuState.addInstance(new MenuSystem());

        var ingameState = createState("ingame");
        ingameState.addInstance(new StartSystem());
        ingameState.addInstance(new SausageSystem());


        // changeState("menu");
        changeState("ingame");
    }

    static function main():Void {
        new Game();
    }

    public function increaseWin() {
    }

    public function increaseLost() {
    }
}

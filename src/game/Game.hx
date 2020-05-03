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

    private var left:Int;
    private var saved:Int;
    private var lost:Int;
    private var leftSpan:js.jquery.JQuery;
    private var savedSpan:js.jquery.JQuery;
    private var lostSpan:js.jquery.JQuery;

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

        var menuState = createState("menu");
        menuState.addInstance(new MenuSystem());

        var gameOverState = createState("gameOver");
        gameOverState.addInstance(new GameOverSystem());

        var ingameState = createState("ingame");
        ingameState.addInstance(new StartSystem());
        ingameState.addInstance(new SausageSystem());

        createUiState("menu", ".menu");
        createUiState("hud", ".hud");
        createUiState("gameOver", ".gameOver");

        mainMenu();
    }

    public override function onGuiLoaded() {
        super.onGuiLoaded();
        leftSpan = new JQuery("span.left");
        lostSpan = new JQuery("span.lost");
        savedSpan = new JQuery("span.saved");
    }

    static function main():Void {
        new Game();
    }

    public function mainMenu() {
        changeState("menu");
        changeUiState("menu");
    }

    public function startGame() {
        changeState("ingame");
        changeUiState("hud");
        left = 10;
        saved = 0;
        lost = 0;
        updateHud();
    }

    public function gameOver() {
        changeState("gameOver");
        changeUiState("gameOver");
    }

    public function hasSausagesLeft() {
        return left > 0;
    }

    public function onNewSausage() {
        --left;
        updateHud();
    }

    public function increaseSaved() {
        ++saved;
        updateHud();
    }

    public function increaseLost() {
        ++lost;
        updateHud();
    }

    private function updateHud() {
        lostSpan.text(""+lost);
        savedSpan.text(""+saved);
        leftSpan.text(""+left);
    }
}

package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class MenuSystem extends ash.core.System {
    private var engine:Engine;

    public function new() {
        super();
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    public override function update(dt:Float) {
        var keys = whiplash.Input.keys;

        if(keys[' '] || whiplash.Input.isButtonJustPressed(Face1)) {
            Game.instance.startGame();
        }
    }
}



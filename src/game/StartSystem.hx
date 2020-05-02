package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class StartNode extends Node<StartNode> {
    public var transform:Transform;
    public var shake:Start;
}

class StartSystem extends ListIteratingSystem<StartNode> {
    private var engine:Engine;

    public function new() {
        super(StartNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:StartNode, dt:Float):Void {
    }

    private function onNodeAdded(node:StartNode) {
    }

    private function onNodeRemoved(node:StartNode) {
    }
}



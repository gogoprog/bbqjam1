package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class SausageNode extends Node<SausageNode> {
    public var transform:Transform;
    public var shake:Sausage;
}

class SausageSystem extends ListIteratingSystem<SausageNode> {
    private var engine:Engine;

    public function new() {
        super(SausageNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:SausageNode, dt:Float):Void {
    }

    private function onNodeAdded(node:SausageNode) {
    }

    private function onNodeRemoved(node:SausageNode) {
    }
}



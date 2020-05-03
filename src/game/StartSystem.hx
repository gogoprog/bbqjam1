package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

import game.SausageSystem;

class StartNode extends Node<StartNode> {
    public var transform:Transform;
    public var start:Start;
}

class StartSystem extends ListIteratingSystem<StartNode> {
    private var engine:Engine;
    private var sausageList:NodeList<SausageNode>;

    public function new() {
        super(StartNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
        sausageList = engine.getNodeList(SausageNode);
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:StartNode, dt:Float):Void {
        if(sausageList.empty) {
            if(Game.instance.hasSausagesLeft()) {
                var e = Factory.createSausage();
                e.get(Transform).position.copyFrom(node.transform.position);
                engine.addEntity(e);
                Game.instance.onNewSausage();
            }
        }
    }

    private function onNodeAdded(node:StartNode) {
    }

    private function onNodeRemoved(node:StartNode) {
    }
}



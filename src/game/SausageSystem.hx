package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class SausageNode extends Node<SausageNode> {
    public var transform:Transform;
    public var sausage:Sausage;
    public var sprite:Sprite;
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
        var transform = node.transform;
        var position = transform.position;

        if(position.y > 1000) {
            engine.removeEntity(node.entity);
        } else {
            var sausage = node.sausage;
            var life = sausage.life;
            var distance = 20 * 16 - position.y;
            var damage = Math.max(400 - distance, 0);
            life -= damage * dt * 0.1;
            var color = untyped Phaser.Display.Color.GetColor(life, life, life);
            node.sprite.tint = color;
            sausage.life = life;
        }
    }

    private function onNodeAdded(node:SausageNode) {
    }

    private function onNodeRemoved(node:SausageNode) {
    }
}



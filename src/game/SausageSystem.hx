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
        var sausage = node.sausage;
        var life = sausage.life;

        if(life > 0) {
            if(position.y > 1000) {
                engine.removeEntity(node.entity);
            } else {
                if(position.x > 2 * 16 && position.x < 22*16) {
                    var distance = 20 * 16 - position.y;
                    var damage = Math.max(400 - distance, 0);
                    life -= damage * dt * 0.1;
                    var color = untyped Phaser.Display.Color.GetColor(life, life, life);
                    node.sprite.tint = color;
                    sausage.life = life;

                    if(life <= 0) {
                        node.sprite.body.velocity.x = 0;
                        node.entity.remove(whiplash.platformer.Character);
                        node.sprite.tint = 0xffffff;
                        node.sprite.play("death");
                        Game.instance.delay(function() {
                            node.entity.remove(Sausage);
                            Game.instance.increaseLost();
                        }, 1);
                    }
                }
            }
        }
    }

    private function onNodeAdded(node:SausageNode) {
    }

    private function onNodeRemoved(node:SausageNode) {
    }
}



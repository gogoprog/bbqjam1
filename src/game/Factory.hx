package game;

import ash.core.Entity;
import whiplash.phaser.*;
import whiplash.math.*;
import whiplash.platformer.Character;

class Factory {
    static var tilemap:phaser.tilemaps.Tilemap;

    static public function preload(scene:phaser.Scene) {
        scene.load.spritesheet('fire', '../data/spritesheets/fire.png', { frameWidth: 32, frameHeight: 64 });
    }

    static public function init(scene:phaser.Scene) {
        tilemap = whiplash.Lib.phaserScene.add.tilemap('level');
        tilemap.addTilesetImage('../textures/black.png', 'black');
        tilemap.addTilesetImage('../textures/grill.png', 'grill');
        tilemap.addTilesetImage('../textures/grass.png', 'grass');
        tilemap.addTilesetImage('../textures/wood.png', 'wood');
        tilemap.addTilesetImage('tiles', 'tiles');
        scene.anims.create({
            key: 'idle',
            frames: [
            untyped { key: 'sausage_idle0' },
            untyped { key: 'sausage_idle1' },
            ],
            frameRate: 5,
            repeat: -1
        });
        scene.anims.create({
            key: 'walk',
            frames: [
            untyped { key: 'sausage_walk0' },
            untyped { key: 'sausage_walk1' },
            untyped { key: 'sausage_walk2' },
            untyped { key: 'sausage_walk1' },
            ],
            frameRate: 10,
            repeat: -1
        });
        scene.anims.create({
            key: 'fire',
            frames: scene.anims.generateFrameNames("fire"),
            frameRate: 10,
            repeat: -1
        });
    }

    static public function createLevel(layer, collision:Bool, depth:Int) {
        var e = new Entity();
        e.add(new TilemapLayer(tilemap, layer, tilemap.tilesets));
        e.get(TilemapLayer).setDepth(depth);
        e.add(new Transform());

        if(collision) {
            e.add(new whiplash.platformer.WorldCollision());
        }

        return e;
    }

    static public function createObjectEntity(obj, props):Entity {
        var e = new Entity();
        var transform = new Transform(obj.x, obj.y);
        e.add(transform);
        return e;
    }

    static public function createObjectHandler() {
        var e = new Entity();
        e.add(new whiplash.platformer.WorldObjectHandler(tilemap.objects, function(obj, props) {
            if(props.entity) {
                var e = createObjectEntity(obj, props);
                objectHandlers[cast props.entity](e, obj, props);
                whiplash.Lib.ashEngine.addEntity(e);
            }

            return true;
        }, 1024));
        return e;
    }

    static public function createPlayer() {
        var e = new Entity();
        // e.name = "player";
        var sprite = new Sprite("sausage");
        sprite.setDepth(9);
        e.add(sprite);
        e.add(new Transform());
        e.get(Transform).position.y = 100;
        e.get(Transform).position.x = 300;
        e.add(new whiplash.platformer.Input());
        e.add(new whiplash.platformer.Character());
        e.get(whiplash.platformer.Character).size.setTo(24, 40);
        e.get(whiplash.platformer.Character).offset.setTo(0, 8);
        e.get(whiplash.platformer.Character).jumpSpeed = -300;
        var anims = e.get(whiplash.platformer.Character).animations;
        anims[Idle] = "idle";
        anims[Walk] = "walk";
        return e;
    }

    static public function createCamera() {
        var e = new Entity();
        e.add(new Transform());
        e.add(new Camera(0, 0, Config.screenWidth, Config.screenHeight));
        e.add(new whiplash.platformer.Camera());
        return e;
    }

    static private var objectHandlers:Map<String, Entity->Dynamic->Dynamic->Void> = [
    "fire" => function(e, obj, props) {
        e.add(new Sprite("fire"));
        e.get(Sprite).play("fire");
        e.get(Sprite).setDepth(1);
        e.get(Sprite).anims.setProgress(Math.random());
    }
            ];
}

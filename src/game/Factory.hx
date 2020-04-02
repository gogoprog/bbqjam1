package game;

import ash.core.Entity;
import whiplash.phaser.*;
import whiplash.math.*;
import whiplash.platformer.Character;

class Factory {
    static var tilemap:phaser.tilemaps.Tilemap;

    static public function preload(scene:phaser.Scene) {
    }

    static public function init(scene:phaser.Scene) {
        tilemap = whiplash.Lib.phaserScene.add.tilemap('level');
        tilemap.addTilesetImage('../textures/grass.png', 'grass');
        tilemap.addTilesetImage('../textures/ground.png', 'ground');
        tilemap.addTilesetImage('../textures/plainground.png', 'plainground');
        untyped window.t = tilemap;
        scene.anims.create({
            key: 'hero_idle',
            frames: [
            untyped { key: 'hero_idle' },
            ],
            frameRate: 5,
            repeat: -1
        });
        scene.anims.create({
            key: 'hero_walk',
            frames: [
            untyped { key: 'hero_walk' },
            untyped { key: 'hero_walk2' },
            ],
            frameRate: 5,
            repeat: -1
        });
    }

    static public function createSky() {
        var e = new Entity();
        e.add(new Sprite("sky"));
        e.add(new Transform());
        return e;
    }

    static public function createLevel(layer, collision:Bool, depth:Int) {
        var e = new Entity();
        e.add(new TilemapLayer(tilemap, layer, tilemap.tilesets));
        e.get(TilemapLayer).setDepth(depth);
        e.add(new Transform());
        e.get(Transform).position.y = 360;

        if(collision) {
            e.add(new whiplash.platformer.WorldCollision());
        }

        return e;
    }

    static public function createObjectEntity(obj, props):Entity {
        var e = new Entity();
        var transform = new Transform(obj.x + tilemap.tileWidth / 2, 360 + obj.y - tilemap.tileHeight / 2);
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
        e.name = "player";
        var sprite = new Sprite("hero_idle");
        sprite.setDepth(9);
        e.add(sprite);
        e.add(new Transform());
        e.get(Transform).position.y = 100;
        e.get(Transform).position.x = 300;
        e.get(Transform).scale.setTo(0.3, 0.3);
        e.add(new whiplash.platformer.Input());
        e.add(new whiplash.platformer.Character());
        e.get(whiplash.platformer.Character).size.setTo(100, 378);
        e.get(whiplash.platformer.Character).offset.setTo(115, 80);
        e.add(new whiplash.platformer.CameraTarget());
        var anims = e.get(whiplash.platformer.Character).animations;
        anims[Idle] = "hero_idle";
        anims[Walk] = "hero_walk";
        return e;
    }

    static public function createSprite(which) {
        var e = new Entity();
        e.add(new Sprite("none"));
        e.add(new Transform());
        return e;
    }

    static public function createCamera() {
        var e = new Entity();
        e.add(new Transform());
        e.add(new Camera(0, 0, Config.screenWidth, Config.screenHeight));
        e.add(new whiplash.platformer.Camera());
        e.get(Camera).setBackgroundColor("#2f471f");
        e.get(whiplash.platformer.Camera).maxY = 64;
        untyped window.c = e.get(Camera);
        return e;
    }

    static public function createParallax(texture, factor, scale = 1.0) {
        var e = new Entity();
        e.add(new TileSprite(Std.int(1280 / scale), 512, texture));
        e.add(new whiplash.platformer.Parallax(factor));
        e.add(new Transform());
        e.get(Transform).position.x = -2;
        e.get(TileSprite).tint = 0x668822;
        e.get(Transform).scale.setTo(scale, scale);
        return e;
    }

    static private var objectHandlers:Map<String, Entity->Dynamic->Dynamic->Void> = [
    "key" => function(e, obj, props) {
        e.add(new Sprite("keyh"));
    },
    "coffre" => function(e, obj, props) {
        e.add(new Sprite("coffre"));
        e.get(Sprite).setDepth(8);
        return e;
    }
            ];
}

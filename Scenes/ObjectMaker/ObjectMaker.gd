extends Node2D

const EXPLOSION = preload("res://Scenes/Explosion/Explosion.tscn")
const POWER_UP = preload("res://Scenes/PowerUp/PowerUp.tscn")
const HOMING_MISSILE = preload("res://Scenes/Bullets/HomingMissile/HomingMissile.tscn")

const BULLETS: Dictionary [BulletBase.BulletType, PackedScene] = {
	BulletBase.BulletType.Player: preload("res://Scenes/Bullets/BulletPlayer/BulletPlayer.tscn"),
	BulletBase.BulletType.Enemy: preload("res://Scenes/Bullets/BulletEnemy/BulletEnemy.tscn"),
	BulletBase.BulletType.Bomb: preload("res://Scenes/Bullets/BulletBomb/BulletBomb.tscn")
}

func _ready() -> void:
	SignalHub.on_create_explosion.connect(on_create_explosion)
	SignalHub.on_create_power_up.connect(on_create_power_up)
	SignalHub.on_create_random_power_up.connect(on_create_random_power_up)
	SignalHub.on_create_bullet.connect(on_create_bullet)
	SignalHub.on_create_homing_missile.connect(on_create_homing_missile)
	
	
func add_object(obj: Node, pos: Vector2) -> void:
	add_child(obj)
	obj.global_position = pos

func on_create_explosion(pos: Vector2, anim_name: String) -> void:
	var scene: Explosion = EXPLOSION.instantiate()
	scene.setup(anim_name)
	Callable(add_object).call_deferred(scene, pos)

func on_create_power_up(pos: Vector2, power_up_type: PowerUp.PowerUpType) -> void:
	var scene: PowerUp = POWER_UP.instantiate()
	scene.setup(power_up_type)
	Callable(add_object).call_deferred(scene, pos)

func on_create_random_power_up(pos: Vector2) -> void:
	var random_power_up = PowerUp.PowerUpType.values().pick_random()
	var scene: PowerUp = POWER_UP.instantiate()
	scene.setup(random_power_up)
	Callable(add_object).call_deferred(scene, pos)

func on_create_homing_missile(pos: Vector2) -> void:
	var scene: HomingMissile = HOMING_MISSILE.instantiate()
	Callable(add_object).call_deferred(scene, pos)

func on_create_bullet(pos: Vector2, direction: Vector2, speed: float, type: BulletBase.BulletType) -> void:
	var scene: BulletBase = BULLETS[type].instantiate()
	scene.setup(direction, speed)
	Callable(add_object).call_deferred(scene, pos)

extends Area2D

class_name Player

@export var bullet_speed: float = 400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shield: Shield = $Shield

const GROUP_NAME: String = "Player"
const MOVEMENT_SPEED: float = 300.0
const SCREEN_MARGIN: Vector2 = Vector2(20, 20)

var _health_boost: int = 25
var _viewport_rect: Rect2

func _ready() -> void:
	_viewport_rect = get_viewport_rect()

func get_input() -> Vector2:
	var v = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)
	if v.x != 0:
		animation_player.play("turn")
		sprite_2d.flip_h = v.x > 0
	else:
		animation_player.play("fly")
	
	return v.normalized()

func _process(delta: float) -> void:
	var input = get_input()
	var limit_left = _viewport_rect.position + SCREEN_MARGIN
	var limit_right = _viewport_rect.end - SCREEN_MARGIN
	global_position += input * delta * MOVEMENT_SPEED
	global_position = global_position.clamp(limit_left, limit_right)

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	SignalHub.emit_on_create_bullet(
	global_position, 
	Vector2.UP, 
	bullet_speed, 
	BulletBase.BulletType.Player)

func take_damage(damage: int) -> void:
	if shield.visible: return
	
	SignalHub.emit_on_player_hit(damage)

func _on_area_entered(area: Area2D) -> void:
	if area is PowerUp:
		match area.power_up_type:
			PowerUp.PowerUpType.Shield:
				shield.enable_shield()
			PowerUp.PowerUpType.Health:
				SignalHub.emit_on_player_health_bonus(_health_boost)
	elif area is Projectile:
		take_damage(area.get_damage())
	elif area.get_parent() is EnemyBase:
		take_damage(area.get_parent().crash_damage)

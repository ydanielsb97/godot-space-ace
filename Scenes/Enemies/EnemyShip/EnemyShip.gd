class_name EnemyShip extends EnemyBase

@export var shoots_at_player: bool = false
@export var aims_at_player: bool = false

@export var bullet_type: BulletBase.BulletType = BulletBase.BulletType.Enemy
@export var bullet_speed: float = 120.0
@export var bullet_direction: Vector2 = Vector2.DOWN
@export var bullet_wait_time: float = 3.0
@export var bullet_wait_time_var: float = 0.5
@export var power_up_chance: float = 0.9

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var laser_timer: Timer = $LaserTimer

var _player_ref: Player
var _can_shoot: bool = true

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref:
		queue_free()
	start_shoot_timer()
	SpaceUtils.play_random_animation(animated_sprite_2d)

func setup(speed: float) -> void:
	_speed = speed

func start_shoot_timer() -> void:
	if !shoots_at_player: return
	
	SpaceUtils.set_and_start_timer(laser_timer, bullet_wait_time, bullet_wait_time_var)

func shoot() -> void:
	if !_can_shoot: return
	
	if aims_at_player:
		bullet_direction = global_position.direction_to(_player_ref.global_position)
	
	SignalHub.emit_on_create_bullet(
		global_position, 
		bullet_direction, 
		bullet_speed, 
		bullet_type)
	
	sound.play()
	start_shoot_timer()

func die() -> void:
	if randf() < power_up_chance:
		SignalHub.emit_on_create_random_power_up(global_position)
	super()

func _on_laser_timer_timeout() -> void:
	shoot()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_can_shoot = false
	await get_tree().create_timer(2).timeout
	queue_free()
	

class_name BulletBase extends Projectile

enum BulletType { Player, Enemy, Bomb }

var _direction: Vector2
var _speed: float

func setup(direction: Vector2, speed: float) -> void:
	_direction = direction
	_speed = speed

func _process(delta: float) -> void:
	position += _direction * _speed * delta
	pass

func blow_up() -> void:
	SignalHub.emit_on_create_explosion(global_position, Explosion.EXPLODE)
	
	super()

extends Projectile

class_name HomingMissile

const ROTATION_SPEED: float = 1.2
const SPEED: float = 80.0
const POINTS: int = 5

var _player_ref: Player

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref:
		queue_free()

func _process(delta: float) -> void:
	var direction_to_player: Vector2 = global_position.direction_to(_player_ref.global_position)
	var angle_to_player: float = transform.x.angle_to(direction_to_player)
	
	rotate(sign(angle_to_player) * min(abs(angle_to_player), ROTATION_SPEED * delta))
	
	position += transform.x * SPEED * delta


func _on_area_entered(area: Area2D) -> void:
	blow_up()
	if area is not Player:
		ScoreManager.increment_score(POINTS)

func blow_up() -> void:
	SignalHub.emit_on_create_explosion(global_position, Explosion.BOOM)
	super()

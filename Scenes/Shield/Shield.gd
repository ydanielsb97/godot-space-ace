extends Area2D

class_name Shield

@export var start_health: int = 5

@onready var sound: AudioStreamPlayer2D = $Sound
@onready var life_timer: Timer = $LifeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _health: int = start_health

func _ready() -> void:
	disable_shield()

func disable_shield() -> void:
	SpaceUtils.toggle_area2d(self, false)
	hide()
	life_timer.stop()

func enable_shield() -> void:
	_health = start_health
	animation_player.play("RESET")
	SpaceUtils.toggle_area2d(self, true)
	life_timer.start()
	show()
	sound.play()

func hit() -> void:
	animation_player.play("hit")
	_health -= 1
	if _health <= 0:
		disable_shield()

func _on_area_entered(area: Area2D) -> void:
	if area is not PowerUp:
		hit()


func _on_life_timer_timeout() -> void:
	disable_shield()

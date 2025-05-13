extends Node2D

class_name Explosion

const BOOM: String = "boom"
const EXPLODE: String = "explode"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _anim_name: String = EXPLODE

func _ready() -> void:
	animated_sprite_2d.animation = _anim_name
	animated_sprite_2d.play()

func setup(anim_name: String) -> void:
	_anim_name = anim_name

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

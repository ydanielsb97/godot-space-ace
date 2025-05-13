
extends Control


@onready var score_label: Label = $VB/ScoreLabel


@export var wait_time: float = .5


var _can_shoot: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.load_main_scene()
	if _can_shoot and event.is_action_pressed("shoot"):
		GameManager.load_main_scene()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	get_tree().paused = false

func _enter_tree() -> void:
	SignalHub.on_player_died.connect(on_player_died)

func on_player_died() -> void:
	get_tree().paused = true
	show()
	score_label.text = "Score:%s (Best:%s)" % [
		ScoreManager.score,
		ScoreManager.high_score
	]
	score_label.show()
	await get_tree().create_timer(wait_time).timeout
	_can_shoot = true

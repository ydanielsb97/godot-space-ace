extends Node2D

const SAUCER = preload("res://Scenes/Enemies/Saucer/Saucer.tscn")

const WAIT_TIME: float = 10.0
const WAIT_VARIATION: float = 4.0

@onready var paths: Node2D = $Paths
@onready var spawn_timer: Timer = $SpawnTimer

var _paths_list: Array[Path2D] = []

func _ready() -> void:
	for path in paths.get_children():
		_paths_list.push_back(path)
	reset_timer()

func reset_timer() -> void:
	SpaceUtils.set_and_start_timer(spawn_timer, WAIT_TIME, WAIT_VARIATION)

func spawn_saucer():
	var saucer: Saucer = SAUCER.instantiate()
	var path: Path2D = _paths_list.pick_random()
	path.add_child(saucer)
	reset_timer()

func _on_spawn_timer_timeout() -> void:
	spawn_saucer()

extends Node2D

const WAVES = preload("res://Resources/Waves.tres")

@onready var paths: Node2D = $Paths
@onready var spawn_timer: Timer = $SpawnTimer

var _wave_count: int = 0
var _wave_gap: float = 4.0
var _speed_factor: float = 1.0
var _paths_list: Array[Path2D] = []

func _ready() -> void:
	for path in paths.get_children():
		_paths_list.push_back(path)
	
	spawn_wave()

func update_speed() -> void:
	if WAVES.wave_is_start(_wave_count):
		_speed_factor *= 1.2
		_wave_gap * 0.8

func start_spawn_timer() -> void:
	spawn_timer.wait_time = _wave_gap
	spawn_timer.start()

func spawn_wave() -> void:
	var path: Path2D = _paths_list.pick_random()
	var wave: EnemyWave = WAVES.get_wave_for_wave_count(_wave_count)
	
	for i in range(0, wave.number):
		path.add_child(create_enemy(wave))
		await get_tree().create_timer(wave.gap, false).timeout
	
	_wave_count += 1
	start_spawn_timer()
	update_speed()

func create_enemy(wave: EnemyWave) -> EnemyShip:
	var new_enemy: EnemyShip = wave.enemy_scene.instantiate()
	new_enemy.setup(wave.speed * _speed_factor)
	return new_enemy


func _on_spawn_timer_timeout() -> void:
	spawn_wave()

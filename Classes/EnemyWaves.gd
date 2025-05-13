extends Resource

class_name EnemyWaves

@export var waves: Array[EnemyWave]

func get_wave_for_wave_count(wave_count: int) -> EnemyWave:
	return waves[wave_count % waves.size()]

func wave_is_start(wave_count: int) -> bool:
	return wave_count % waves.size() == 0

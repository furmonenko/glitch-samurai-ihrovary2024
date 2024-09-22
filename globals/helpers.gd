extends Node

func throw_error(error_text :String, caller :String):
	print(error_text + caller + " script")
	get_tree().quit()

func slow_motion_start(slow_motion_duration = 0.5, slow_motion_scale = 0.5) -> void:
	# Задаємо слоу-моушн
	Engine.time_scale = slow_motion_scale
	# Запускаємо таймер для відновлення швидкості
	await get_tree().create_timer(slow_motion_duration).timeout
	slow_motion_stop()

func slow_motion_stop() -> void:
	# Повертаємо звичайну швидкість
	Engine.time_scale = 1.0

func trigger_hitstop(duration: float = 0.1):
	get_tree().paused = true
	await get_tree().create_timer(duration).timeout
	get_tree().paused = false

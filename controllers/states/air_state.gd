extends PlayerState
class_name AirState

# Параметри для контролю руху

func _enter() -> void:
	# Перехід у стан повітря
	velocity = character.velocity
	state_machine.switch_state("air")
	
	# Якщо персонаж тільки стрибає
	if character.is_on_floor():
		velocity.y = -character.stats_resource.jump_force

func _update(delta: float) -> void:
	handle_air_movement(delta)

func handle_air_movement(delta: float) -> void:
	# Рух по горизонталі в повітрі
	
	if !character.is_dead:
		var input_direction = 0

		if Input.is_action_pressed("move_right"):
			input_direction = 1
		elif Input.is_action_pressed("move_left"):
			input_direction = -1

		# Оброт персонажа на основі напрямку
		if input_direction > 0:
			character.transform.x.x = 1
		elif input_direction < 0:
			character.transform.x.x = -1

		# Максимальна швидкість у повітрі
		velocity.x = input_direction * character.stats_resource.max_air_speed

	# Гравітація
	velocity.y += character.stats_resource.gravity

	# Обмеження швидкості падіння
	if velocity.y > character.stats_resource.max_fall_speed:
		velocity.y = character.stats_resource.max_fall_speed

	# Задаємо параметр blend_position для падіння або стрибка
	if velocity.y > 0:
		# Персонаж падає
		animation_tree.set("parameters/Air/blend_position", -1)
	elif velocity.y < 0:
		# Персонаж стрибає
		animation_tree.set("parameters/Air/blend_position", 1)

	# Перевірка приземлення
	if character.is_on_floor():
		# Завершуємо стейт повітря
		if character.is_dead:
			dispatch("die_after_falling")
			return
		dispatch(EVENT_FINISHED)

	# Застосування швидкості до персонажа
	character.velocity = velocity
	character.move_and_slide()

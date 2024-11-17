extends PlayerState
class_name RunState


func _enter() -> void:
	velocity = character.velocity
	
	# Міняємо умови в animation_tree. Переключаємо анімацію.
	# TODO: зробити з "run" @export var яка відповідатиме за назву умови в animation_tree.
	state_machine.switch_state("run")

func handle_movement(input_direction: int, delta: float) -> void:
	# Додаємо гравітацію
	
	# Якщо персонаж змінює напрямок, обнуляємо швидкість
	if (input_direction > 0 and velocity.x < 0) or (input_direction < 0 and velocity.x > 0):
		velocity.x = 0

	# Оброт персонажа на основі напрямку
	if input_direction != 0:
		if character is Shieldman:
			await get_tree().create_timer(0.5).timeout
			
		if input_direction > 0:
			character.transform.x.x = 1
		elif input_direction < 0:
			character.transform.x.x = -1

		# Прискорення при русі
		velocity.x = move_toward(velocity.x, input_direction * character.stats_resource.max_speed, character.stats_resource.acceleration)
	else:
		# Децелерація при зупинці
		velocity.x = move_toward(velocity.x, 0, character.stats_resource.deceleration)

	# Якщо швидкість близька до нуля, вважаємо, що персонаж зупинився
	if abs(velocity.x) < 0.1:
		velocity.x = 0
		dispatch(EVENT_FINISHED)

	# Переміщення персонажа і застосування гравітації
	character.velocity = velocity
	character.move_and_slide()

	# Перевірка, чи персонаж на землі, і перехід в air_state
	if !character.is_on_floor() and %Air:
		state_machine.change_active_state(%Air)

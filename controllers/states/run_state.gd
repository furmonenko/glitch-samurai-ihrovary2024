extends State
class_name RunState

# Параметри для контролю руху
@export var speed: float = 150.0
@export var jump_force: float = 400.0
@export var gravity: float = 50.0

# Параметри для акселерації та децелерації
@export var acceleration: float = 20.0
@export var deceleration: float = 1.0
@export var max_speed: float = 200.0

var velocity :Vector2

func _enter() -> void:
	# Перемикаємо стан на RUN
	velocity = character.velocity
	state_machine.switch_state("run")

func handle_movement(input_direction: int, delta: float) -> void:
	# Якщо персонаж змінює напрямок, обнуляємо швидкість
	if (input_direction > 0 and velocity.x < 0) or (input_direction < 0 and velocity.x > 0):
		velocity.x = 0

	# Оброт персонажа на основі напрямку
	if input_direction != 0:
		if input_direction > 0:
			character.transform.x.x = 1
		elif input_direction < 0:
			character.transform.x.x = -1

		# Прискорення при русі
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration)
	else:
		# Децелерація при зупинці
		velocity.x = move_toward(velocity.x, 0, deceleration)

	# Якщо швидкість близька до нуля, вважаємо, що персонаж зупинився
	if abs(velocity.x) < 0.1:
		velocity.x = 0
		dispatch(EVENT_FINISHED)

	# Застосування швидкості до персонажа
	character.velocity = velocity
	character.move_and_slide()

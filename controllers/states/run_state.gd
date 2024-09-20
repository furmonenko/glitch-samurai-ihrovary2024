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

@onready var velocity = character.velocity

func _enter() -> void:
	# Перемикаємо стан на RUN
	state_machine.switch_state(StateMachine.STATE.RUN)

func _update(_delta: float) -> void:
	handle_movement(_delta)

func handle_movement(delta: float) -> void:
	# Рух по горизонталі
	var input_direction = 0

	if Input.is_action_pressed("move_right"):
		input_direction = 1
	elif Input.is_action_pressed("move_left"):
		input_direction = -1

	# Якщо персонаж змінює напрямок, обнуляємо швидкість
	if (input_direction > 0 and velocity.x < 0) or (input_direction < 0 and velocity.x > 0):
		velocity.x = 0

	# Оброт персонажа на основі напрямку
	if input_direction > 0:
		character.transform.x.x = 1
	elif input_direction < 0:
		character.transform.x.x = -1

	# Обробка акселерації та децелерації
	if input_direction != 0:
		# Прискорення при русі
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration)
	else:
		# Децелерація при зупинці
		velocity.x = move_toward(velocity.x, 0, deceleration)

	# Якщо швидкість = 0, стан завершений
	if velocity == Vector2.ZERO:
		dispatch(EVENT_FINISHED)

	# Застосування швидкості до персонажа
	character.velocity = velocity
	character.move_and_slide()

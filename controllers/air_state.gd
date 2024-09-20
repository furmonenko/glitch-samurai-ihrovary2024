extends State
class_name AirState

# Параметри для контролю руху
@export var jump_force: float = 600.0
@export var gravity: float = 50.0
@export var max_air_speed: float = 150.0

@onready var velocity = character.velocity

func _enter() -> void:
	# Перехід у стан повітря
	state_machine.switch_state(StateMachine.STATE.AIR)
	
	# Якщо персонаж тільки стрибає
	if character.is_on_floor():
		velocity.y = -jump_force

func _update(delta: float) -> void:
	handle_air_movement(delta)

func handle_air_movement(delta: float) -> void:
	# Рух по горизонталі в повітрі
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
	velocity.x = input_direction * max_air_speed

	# Гравітація
	velocity.y += gravity
	
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
		dispatch(EVENT_FINISHED)

	# Застосування швидкості до персонажа
	character.velocity = velocity
	character.move_and_slide()

extends State
class_name PatrolState

@export var patrol_time: float = 3.0
@export var wait_time: float = 5.0

var patrol_timer: Timer
var wait_timer: Timer

var SWITCH_STAGE: StringName = "switch_stage"

@onready var starting_pos: Vector2
var is_moving_forward: bool = false
var is_moving: bool = false

func _enter():
	# Ініціалізація стану
	state_machine.switch_state("idle")
	starting_pos = character.global_position
	init_timers()
	wait_timer.start()  # Спочатку чекаємо

func _update(delta):
	if controller.is_target_in_range(controller.spot_range):
		dispatch(SWITCH_STAGE)
		
	if is_moving:
		state_machine.switch_state("run")
		if is_moving_forward:
		# Рух вперед
			handle_movement_patrol(1, delta)  # Наприклад, рух вправо
		else:
			# Рух назад
			handle_movement_patrol(-1, delta)  # Повернення до початкової точки
		
	
func wait():
	# Переходимо в стан очікування
	state_machine.switch_state("idle")
	wait_timer.start()


func init_timers():
	# Ініціалізація таймера очікування
	wait_timer = Timer.new()
	wait_timer.wait_time = wait_time
	wait_timer.one_shot = true
	add_child(wait_timer)
	wait_timer.timeout.connect(_on_wait_timer_stopped)

	# Ініціалізація таймера патрулювання
	patrol_timer = Timer.new()
	patrol_timer.wait_time = patrol_time
	patrol_timer.one_shot = true
	add_child(patrol_timer)
	patrol_timer.timeout.connect(_on_patrol_timer_stopped)

func _on_patrol_timer_stopped():
	is_moving = not is_moving
	wait()
	# Після руху вперед змінюємо напрямок11245
	

func _on_wait_timer_stopped():
	patrol_timer.start()
	# Після завершення очікування починаємо патрулювання
	is_moving = not is_moving
	is_moving_forward = not is_moving_forward

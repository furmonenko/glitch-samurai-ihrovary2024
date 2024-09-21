extends Controller
class_name PlayerController

@onready var idle_state: LimboState = %GlitchSamurai/%Idle
@onready var run_state: RunState = %GlitchSamurai/%Run
@onready var air_state: AirState = %GlitchSamurai/%Air
@onready var attack_state: AttackState = %GlitchSamurai/%Attack
@onready var death_state: DeathState = %GlitchSamurai/%Death

func _ready() -> void:
	character.died.connect(func(dead_character: Character):
		dead_character.is_dead = true
		if dead_character.is_on_floor():
			state_machine.playback
		)
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, idle_state, air_state.EVENT_FINISHED)
	
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, death_state, &"die_after_falling")

func handle_states(delta :float):
	super(delta)
	
	if Input.is_action_just_pressed("interact"):
		character.died.emit(character)
		return
	
	# Перевірка на стрибок (входження в стан AirState)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		state_machine.change_active_state(air_state)

	# Перевірка на атаку (входження в стан AttackState)
	elif Input.is_action_just_pressed("attack"):
		if state_machine.is_active() and character.is_on_floor() and state_machine.get_active_state() != attack_state:
			state_machine.change_active_state(attack_state)
		elif state_machine.get_active_state() == attack_state:
			attack_state.attack()

	# Перевірка на переміщення (входження в стан MoveState)
	# Перевірка на переміщення (входження в стан MoveState)
	elif Input.get_axis("move_left", "move_right") != 0 and state_machine.get_active_state() != air_state and state_machine.get_active_state() != attack_state:
		# Переходимо в стан руху, тільки якщо персонаж не в повітрі
		if character.is_on_floor():
			if state_machine.is_active() and state_machine.get_active_state() != run_state:
				state_machine.change_active_state(run_state)
			elif state_machine.get_active_state() == run_state:
				run_state.handle_movement(Input.get_axis("move_left", "move_right"), delta)

# Якщо персонаж у RunState, але axis = 0, повертаємо його в IdleState
	elif state_machine.get_active_state() == run_state:
		if Input.get_axis("move_left", "move_right") == 0 and character.is_on_floor():
			state_machine.change_active_state(idle_state)
		elif !character.is_on_floor():
			state_machine.change_active_state(air_state)

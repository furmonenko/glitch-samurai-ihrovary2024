extends Controller
class_name PlayerController

signal dead

@onready var idle_state: LimboState = %GlitchSamurai/%Idle
@onready var run_state: RunState = %GlitchSamurai/%Run
@onready var air_state: AirState = %GlitchSamurai/%Air
@onready var attack_state: AttackState = %GlitchSamurai/%Attack
@onready var death_state: DeathState = %GlitchSamurai/%Death

var combo_count: int = 0  # Лічильник комбо-атак
var max_combo_attacks: int = 3  # Максимальна кількість атак у комбо

func _ready() -> void:
	character.died.connect(func(dead_character: Character):
		dead_character.is_dead = true
		if dead_character.is_on_floor():
			state_machine.change_active_state(death_state)
			dead.emit()
		)
	
	if character.hitbox:
		character.hitbox.hit_target.connect(func():
			%PlayerCamera.start_screen_shake()
			)
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, idle_state, air_state.EVENT_FINISHED)
	
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, death_state, &"die_after_falling")

func handle_states(delta: float) -> void:
	super(delta)
	
	if character.is_dead:
		return
	
	if Input.is_action_just_pressed("interact"):
		character.died.emit(character)
		return
	
	# Перевірка на стрибок (входження в стан AirState)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		state_machine.change_active_state(air_state)

	# Перевірка на атаку (входження в стан AttackState)
	elif Input.is_action_just_pressed("attack"):
		if state_machine.get_active_state() != attack_state and character.is_on_floor():
			# Починаємо атаку, якщо персонаж на землі і не атакує
			combo_count = 1
			state_machine.change_active_state(attack_state)
			attack_state.start_attack(combo_count)
		elif state_machine.get_active_state() == attack_state and combo_count < max_combo_attacks:
			# Якщо атака вже триває, але гравець натискає знову, зберігаємо це
			attack_state.attack_pressed_during_animation = true
			# Збільшуємо комбо-лічильник відразу після натискання
			combo_count += 1

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

	# Скидання комбо після завершення атаки
	if state_machine.get_active_state() != attack_state:
		combo_count = 0  # Скидаємо лічильник комбо, якщо персонаж не в стані атаки

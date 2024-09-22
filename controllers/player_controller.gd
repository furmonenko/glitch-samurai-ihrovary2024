extends Controller
class_name PlayerController

signal dead
signal glitch_exited

@onready var idle_state: LimboState = %GlitchSamurai/%Idle
@onready var run_state: RunState = %GlitchSamurai/%Run
@onready var air_state: AirState = %GlitchSamurai/%Air
@onready var attack_state: AttackState = %GlitchSamurai/%Attack
@onready var death_state: DeathState = %GlitchSamurai/%Death
@onready var glitch_state: GlitchState = $GlitchSamurai/LimboHSM/Glitch
@onready var run_sound = $GlitchSamurai/Sounds/RunSound
@onready var jump_sound = $GlitchSamurai/Sounds/JumpSound

@export var energy: float = 400.0  # Максимальна енергія
@export var energy_decrease_rate: float = 20.0  # Скільки енергії зменшувати за секунду
@onready var attack_sound = $GlitchSamurai/Sounds/AttackSound

var combo_count: int = 0  # Лічильник комбо-атак
var max_combo_attacks: int = 3  # Максимальна кількість атак у комбо

func _ready() -> void:
	character.died.connect(func(dead_character: Character):
		dead_character.is_dead = true
		if dead_character.is_on_floor() || state_machine.get_active_state() == glitch_state:
			state_machine.change_active_state(death_state)
			dead.emit()
		)
	
	if character.hitbox:
		character.hitbox.hit_target.connect(func(damaged_character: Character):
			%PlayerCamera.start_screen_shake()
			if damaged_character.is_dead:
				pass
				# Helpers.slow_motion_start(0.5)
			)
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, idle_state, air_state.EVENT_FINISHED)
	state_machine.add_transition(glitch_state, idle_state, glitch_state.EVENT_FINISHED)
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	state_machine.add_transition(air_state, death_state, &"die_after_falling")

func handle_states(delta: float) -> void:
	super(delta)
	
	if character.is_dead:
		return

	if state_machine.get_active_state() != run_state:
		run_sound.stop()
	# Перевірка на глітч
	if Input.is_action_just_pressed("interact") and state_machine.get_active_state() != glitch_state:
		state_machine.change_active_state(glitch_state)
		return
		
	if state_machine.get_active_state() == glitch_state:
		# Зменшуємо енергію, поки персонаж у глітч-стані
		energy -= energy_decrease_rate * delta

		# Якщо енергія закінчилася, виходимо з глітч-стану
		if energy <= 0:
			dead.emit()
			glitch_state._exit()
			state_machine.change_active_state(idle_state)
			return
			
		$HUD/Control/ProgressBar.value = energy
		
		if Input.is_action_just_pressed("interact"):
			glitch_state._exit()
			state_machine.change_active_state(idle_state)
			return

		glitch_state.handle_glitch_movement(delta)
	
	# Перевірка на стрибок (входження в стан AirState)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		state_machine.change_active_state(air_state)
		jump_sound.play()
		

	# Перевірка на атаку (входження в стан AttackState)
	elif Input.is_action_just_pressed("attack"):
		var attack_sound_pitch = randf_range(0.9, 1.1)
		attack_sound.pitch_scale = attack_sound_pitch
		attack_sound.play()
		
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
		if !run_sound.playing:
			run_sound.play()

	elif state_machine.get_active_state() == run_state:
		# Якщо персонаж біжить, але зупинився на краю, переконайтеся, що ми перевіряємо стан підлоги кожного кадру
		if Input.get_axis("move_left", "move_right") == 0 or not character.is_on_floor():
			state_machine.change_active_state(idle_state)
			run_sound.stop()
		elif !character.is_on_floor():
			state_machine.change_active_state(air_state)
			run_sound.stop()
		

	# Скидання комбо після завершення атаки
	if state_machine.get_active_state() != attack_state:
		combo_count = 0  # Скидаємо лічильник комбо, якщо персонаж не в стані атаки

extends Controller
class_name PlayerController

signal dead
signal glitch_exited
signal play_glitch_once

@onready var idle_state: LimboState = %GlitchSamurai/%Idle
@onready var run_state: RunState = %GlitchSamurai/%Run
@onready var air_state: AirState = %GlitchSamurai/%Air
@onready var attack_state: AttackState = %GlitchSamurai/%Attack
@onready var death_state: DeathState = %GlitchSamurai/%Death
@onready var glitch_state: GlitchState = $GlitchSamurai/LimboHSM/Glitch
@onready var run_sound = $GlitchSamurai/Sounds/RunSound
@onready var jump_sound = $GlitchSamurai/Sounds/JumpSound
@onready var attack_sound = $GlitchSamurai/Sounds/AttackSound
@onready var glitch_bar = $HUD/Control/ProgressBar
@onready var cooldown = $GlitchSamurai/Timers/Cooldown
@onready var combo_reset = $GlitchSamurai/Timers/ComboReset
@onready var damage_component = $GlitchSamurai/DamageComponent


var current_level

var combo_count: int = 0  # Лічильник комбо-атак
var max_combo_attacks: int = 3  # Максимальна кількість атак у комбо

@onready var scene_glitch = $HUD/SceneGlitch
@onready var health_component = $GlitchSamurai/HealthComponent
@onready var hurtbox = $GlitchSamurai/Hurtbox

@export var damage_numbers: PackedScene

func _ready() -> void:
	current_level = $'.'.get_parent()
	
	init_stats()
	
	scene_glitch.animation_player.play("scene_glitch")
	
	hurtbox.reduce_energy.connect(func(damage_amount):
		%PlayerCamera.start_screen_shake()
		scene_glitch.glitch.visible = true
		scene_glitch.animation_player.play("hit_glitch")
		
		glitch_bar.value -= damage_amount
		
		)
	
	character.died.connect(func(dead_character: Character):
		dead_character.is_dead = true
		if dead_character.is_on_floor() || state_machine.get_active_state() == glitch_state:
			state_machine.change_active_state(death_state)
			dead.emit()
			await get_tree().create_timer(0.8).timeout
			Helpers.emit_signal("character_died", current_level.level_idx)
		)
	
	character.hitbox.hit_target.connect(func(damaged_character: Character):
		%PlayerCamera.start_screen_shake()
		scene_glitch.glitch.visible = true
			
		scene_glitch.animation_player.play("hit_glitch")
		spawn_damage_text(damaged_character)
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

func _process(delta):
	super(delta)
	
	%MaxHPAmount.text = str(character.stats_resource.max_hp)
	%CurrentHPAmount.text = str(health_component.current_hp)
	%DamageAmount.text = str(character.stats_resource.damage)
	%CritChanceAmount.text = str(character.stats_resource.crit_chance)
	%CritMultAmount.text = str(character.stats_resource.crit_multiplier)
	
func handle_states(delta: float) -> void:
	super(delta)
	
	
	if character.is_dead:
		return
		
	if state_machine.get_active_state() != run_state:
		run_sound.stop()
		
	# Перевірка на глітч
	if state_machine.get_active_state() != attack_state and combo_reset.is_stopped():
		combo_reset.start()
		combo_count = 0
	
	
	if Input.is_action_just_pressed("interact") and state_machine.get_active_state() != glitch_state:
		state_machine.change_active_state(glitch_state)
		return
		
	if state_machine.get_active_state() == glitch_state:
		# Зменшуємо енергію, поки персонаж у глітч-стані
		health_component.current_hp -= character.stats_resource.hp_decrease_rate * delta
		glitch_bar.value = health_component.current_hp 
		

		# Якщо енергія закінчилася, виходимо з глітч-стану
		if health_component.current_hp <= 0:
			dead.emit()
			glitch_state._exit()
			state_machine.change_active_state(idle_state)
			return
			
		
		if Input.is_action_just_pressed("interact"):
			glitch_state._exit()
			state_machine.change_active_state(idle_state)
			return
		

		glitch_state.handle_glitch_movement(delta)
	
	# Перевірка на стрибок (входження в стан AirState)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		state_machine.change_active_state(air_state)
		jump_sound.play()
		
	if Input.is_action_pressed("attack") and state_machine.get_active_state() == air_state and character.is_on_floor():
		state_machine.change_active_state(idle_state)

	# Перевірка на атаку (входження в стан AttackState)
	if Input.is_action_pressed("attack") and cooldown.is_stopped() and state_machine.get_active_state() != air_state:
		var attack_sound_pitch = randf_range(0.9, 1.1)
		attack_sound.pitch_scale = attack_sound_pitch
		
		damage_component.damage_amount = character.stats_resource.damage
		
		var random_crit_value = randi() % 100
		if random_crit_value < character.stats_resource.crit_chance * 100:
			damage_component.damage_amount *= character.stats_resource.crit_multiplier
			
		
		
		if state_machine.get_active_state() != attack_state and character.is_on_floor():
			state_machine.change_active_state(attack_state)
			cooldown.start()
			attack_sound.play()
			combo_count += 1
			
			
			if attack_state.get_blendspace_animations_count() <= combo_count:
				combo_count = 0
		
		
		
	# Перевірка на переміщення (входження в стан MoveState)
	elif Input.get_axis("move_left", "move_right") != 0 and state_machine.get_active_state() != air_state and state_machine.get_active_state() != attack_state:
		# Переходимо в стан руху, тільки якщо персонаж не в повітрі
		if character.is_on_floor():
			if state_machine.is_active() and state_machine.get_active_state() != run_state:
				state_machine.change_active_state(run_state)
			elif state_machine.get_active_state() == run_state:
				run_state.handle_movement(Input.get_axis("move_left", "move_right"), delta)

	elif state_machine.get_active_state() == run_state:
		# Якщо персонаж біжить, але зупинився на краю, переконайтеся, що ми перевіряємо стан підлоги кожного кадру
		if Input.get_axis("move_left", "move_right") == 0 or not character.is_on_floor():
			state_machine.change_active_state(idle_state)
		elif !character.is_on_floor():
			state_machine.change_active_state(air_state)
		
func step_sound():
	var step_sound_pitch = randf_range(0.9, 1.1)
	run_sound.pitch_scale = step_sound_pitch
	run_sound.play()

func init_stats():
	cooldown.wait_time = character.stats_resource.attack_speed
	glitch_bar.max_value = health_component.max_hp
	glitch_bar.value = health_component.max_hp
	glitch_bar.step = 2.0

func spawn_damage_text(damaged_character: Character):
	var damage_numbers_inst = damage_numbers.instantiate()
	add_child(damage_numbers_inst)
	damage_numbers_inst.global_position = damaged_character.alert_point.global_position
	damage_numbers_inst.damage_amount.text = str(damage_component.damage_amount)
	damage_numbers_inst.damage_particle.emitting = true

	

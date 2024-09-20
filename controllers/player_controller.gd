extends Node2D

@onready var hsm: LimboHSM = %LimboHSM
@onready var idle_state: LimboState = %Idle
@onready var move_state: LimboState = %Run
@onready var air_state: AirState = %Air
@onready var attack_state: AttackState = %Attack  # Додаємо стан атаки

@onready var character: CharacterBody2D = %GlitchSamurai

# Параметри для контролю руху
@export var speed: float = 150.0
@export var jump_force: float = 500.0
@export var gravity: float = 50.0

# Параметри для акселерації та децелерації
@export var acceleration: float = 25.0
@export var deceleration: float = 100.0
@export var max_speed: float = 200.0

@onready var velocity = character.velocity

func _ready() -> void:
	_init_state_machine()

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	hsm.add_transition(air_state, idle_state, air_state.EVENT_FINISHED)
	
	hsm.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)

	hsm.initialize(self)
	hsm.set_active(true)

func _process(delta: float) -> void:
	# Перевірка на стрибок (входження в стан AirState)
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		hsm.change_active_state(air_state)

	# Перевірка на атаку (входження в стан AttackState)
	elif Input.is_action_just_pressed("attack") and hsm.get_active_state() != attack_state:
		if hsm.is_active() and character.is_on_floor():
			hsm.change_active_state(attack_state)

	# Перевірка на переміщення (входження в стан MoveState)
	elif Input.get_axis("move_left", "move_right") != 0 and hsm.get_active_state() != air_state and hsm.get_active_state() != attack_state:
		# Переходимо в стан руху, тільки якщо персонаж не в повітрі
		if hsm.get_active_state() != move_state and character.is_on_floor():
			if hsm.is_active():
				hsm.change_active_state(move_state)
	
	# Перевірка на повернення в IdleState, якщо персонаж не рухається
	elif hsm.get_active_state() == move_state and Input.get_axis("move_left", "move_right") == 0 and character.is_on_floor():
		hsm.change_active_state(idle_state)

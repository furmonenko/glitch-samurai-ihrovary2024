extends Node
class_name Controller

@export var character: Character
@export var state_machine: StateMachine

# Параметри для контролю руху
@export var speed: float = 150.0
@export var jump_force: float = 500.0
@export var gravity: float = 50.0

# Параметри для акселерації та децелерації
@export var acceleration: float = 25.0
@export var deceleration: float = 100.0
@export var max_speed: float = 200.0

@onready var velocity = character.velocity

func _process(delta: float) -> void:
	if !character:
		Helpers.throw_error("No character controlled by ", name)
	handle_states(delta)

"""
	Функція в якій ініціалізуєм стейт машину.
	Тут додаються всі переходи (add_transition() і вмикається сама машина)
"""
func _init_state_machine() -> void:
	if state_machine:
		state_machine.initialize(self)
		state_machine.set_active(true)
	else:
		Helpers.throw_error("State machine is null in ", name)

"""
	Функція в якій відбувається переключення між стейтами.
	Основна функція, яка відповідає за поведінку керованого юніта.
"""
func handle_states(delta: float):
	pass

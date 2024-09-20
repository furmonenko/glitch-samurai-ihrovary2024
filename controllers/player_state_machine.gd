extends LimboHSM
class_name StateMachine

@export var animation_tree: AnimationTree
@export var character: CharacterBody2D

enum STATE {IDLE, RUN, ATTACK, AIR, DEFAULT}

var state_conditions: Dictionary = {}
var current_state: STATE = STATE.DEFAULT

func _ready() -> void:
	# Ініціалізуємо словник з параметрами анімації
	state_conditions[STATE.IDLE] = "parameters/conditions/idle"
	state_conditions[STATE.RUN] = "parameters/conditions/running"
	state_conditions[STATE.AIR] = "parameters/conditions/jumping"
	state_conditions[STATE.ATTACK] = "parameters/conditions/attacking"

func switch_state(target_state: STATE):
	for state in state_conditions.keys():
		# Отримуємо шлях до параметра анімації
		var condition_path = state_conditions[state]
		# Якщо це цільовий стан, активуємо його
		if state == target_state:
			animation_tree.set(condition_path, true)
		else:
			animation_tree.set(condition_path, false)
	
	current_state = target_state

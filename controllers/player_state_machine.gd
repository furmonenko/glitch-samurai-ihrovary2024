extends LimboHSM
class_name StateMachine

var character: CharacterBody2D
var animation_tree: AnimationTree

@export var state_conditions: Dictionary = {}

var current_state: String = "idle"

func _ready() -> void:
	init_state_machine()
	create_state_conditions()

func init_state_machine():
	if get_parent() is Character:
		character = get_parent()
		
	if character.get_anim_tree():
		animation_tree = character.get_anim_tree()
		
	for state in get_children():
		if state is State:
			state.character = character
			state.animation_tree = animation_tree

func create_state_conditions():
	state_conditions["idle"] = "parameters/conditions/idle"
	state_conditions["run"] = "parameters/conditions/running"
	state_conditions["attack"] = "parameters/conditions/attacking"
	state_conditions["death"] = "parameters/conditions/dead"
	
func switch_state(target_state: String):
	for state in state_conditions.keys():
		# Отримуємо шлях до параметра анімації
		var condition_path = state_conditions[state]
		# Якщо це цільовий стан, активуємо його
		if state == target_state:
			animation_tree.set(condition_path, true)
		else:
			animation_tree.set(condition_path, false)
	
	current_state = target_state

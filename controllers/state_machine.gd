extends LimboHSM
class_name StateMachine

@export var character: CharacterBody2D
@export var animation_tree: AnimationTree

@export var state_conditions: Dictionary = {}

# Or uose &"character_died"
var CHARACTER_DIED :StringName = "character_died"

var current_state: String = "idle"

func _ready() -> void:
	init_state_machine()
	create_state_conditions()

func init_state_machine():
	if character is Character:
		character = get_parent()
		
	if character.get_anim_tree():
		animation_tree = character.get_anim_tree()
		
	for state in get_children():
		if state is State:
			state.character = character
			state.animation_tree = animation_tree
			state.initialize_state()

func create_state_conditions():
	state_conditions["idle"] = "parameters/conditions/idle"
	state_conditions["run"] = "parameters/conditions/running"
	state_conditions["attack"] = "parameters/conditions/attacking"
	state_conditions["death"] = "parameters/conditions/dead"
	
# Ця функція сетитів всі умови в animation_tree на false, а умову анімаціїї,
# яку потрібно зараз програвати на true
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

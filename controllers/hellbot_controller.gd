extends AIController
class_name HellbotController

@export var shoot_range: float = 80.0


func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, shoot_state, idle_state.START_SHOOT)
	state_machine.add_transition(shoot_state, idle_state, shoot_state.EVENT_FINISHED)

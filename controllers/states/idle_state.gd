extends PlayerState
class_name IdleState

@export var air_state: AirState

var FOUND_ENEMY :StringName = "found_enemy"

func _enter() -> void:
	state_machine.switch_state("idle")

func _update(delta: float) -> void:
	if air_state:
		if !air_state:
			return
		if !character.is_on_floor():
			state_machine.change_active_state(air_state)

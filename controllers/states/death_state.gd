extends State
class_name DeathState

func _enter() -> void:
	state_machine.switch_state(StateMachine.STATE.DEAD)
	die()

func _update(delta: float) -> void:
	if !character.is_on_floor():
		character.velocity.y = 40
		character.move_and_slide()
	
func die():
	Helpers.slow_motion_start(2, 0.2)
	var tween = get_tree().create_tween()
	tween.tween_property(%Camera2D, "zoom", Vector2(0.4, 0.4), 2)

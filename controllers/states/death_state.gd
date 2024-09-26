extends State
class_name DeathState

@export var player_camera :Camera2D

func _enter() -> void:
	die()

func _update(delta: float) -> void:
	if !character.is_on_floor():
		character.velocity.y = 40
		character.move_and_slide()
	 
func die():
	state_machine.switch_state("death")
	
	if player_camera:
		Helpers.slow_motion_start(2, 0.2)
		var tween = get_tree().create_tween()
		tween.tween_property(player_camera, "zoom", Vector2(0.4, 0.4), 2)

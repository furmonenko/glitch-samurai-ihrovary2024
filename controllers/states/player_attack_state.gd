extends AttackState
class_name PlayerAttackState


func _enter() -> void:
	print(controller.combo_count)
	start_attack(controller.combo_count) 

func start_attack(_combo_count: int) -> void:
		
	state_machine.switch_state("attack")
	animation_tree.set("parameters/Attack/blend_position", _combo_count)


func _on_animation_finished(animation_name: String) -> void:
	dispatch(EVENT_FINISHED)

func get_blendspace_animations_count():
	var blend_space = animation_tree.tree_root.get_node("Attack")
	if blend_space is AnimationNodeBlendSpace1D:
		return blend_space.get_blend_point_count()
	else:
		return 1

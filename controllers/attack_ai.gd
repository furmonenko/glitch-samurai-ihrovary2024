extends State
class_name AttackStateAI


func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)
	
func _enter():
	state_machine.switch_state("attack")
	animation_tree.set("parameters/Attack/blend_position", get_random_animation_index())

	
func _on_animation_finished(anim_name: String):
	
	dispatch(EVENT_FINISHED)
	controller.cooldown_timer.start()
	
	
func get_blendspace_animations_count():
	var blend_space = animation_tree.tree_root.get_node("Attack")
	if blend_space is AnimationNodeBlendSpace1D:
		return blend_space.get_blend_point_count()
	else:
		return 1

func get_random_animation_index():
	return randi_range(0, get_blendspace_animations_count() - 1)

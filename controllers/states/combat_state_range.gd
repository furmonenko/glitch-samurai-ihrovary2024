extends CombatStateMelee
class_name CombatStateRange

func _update(delta):
	if controller.is_target_in_range(controller.shoot_range) and !controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped():
		shoot()
	elif controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped() and animation_tree.get("parameters/playback").get_current_node() == "Idle":
		attack()
	elif !controller.is_target_in_range(controller.shoot_range) and !animation_tree.get("parameters/playback").get_current_node() == "Attack":
		move_to_enemy(delta)
	else:
		state_machine.switch_state("idle")
		turn_towards_target()
		


func get_blendspace_shoot_animations_count():
	var blend_space = animation_tree.tree_root.get_node("Shoot")
	if blend_space is AnimationNodeBlendSpace1D:
		return blend_space.get_blend_point_count()
	else:
		return 1

func get_random_animation_index():
	return randi_range(0, get_blendspace_animations_count() - 1)

func shoot():
	if get_blendspace_animations_count() == 1:
		state_machine.switch_state("shoot")
		controller.cooldown_timer.start()
	else:
		state_machine.switch_state("shoot")
		animation_tree.set("parameters/Shoot/blend_position", get_random_animation_index())
		controller.cooldown_timer.start()

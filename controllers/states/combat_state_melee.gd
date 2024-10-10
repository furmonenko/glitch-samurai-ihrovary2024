extends State
class_name CombatStateMelee

func _update(delta):
	if controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped() and animation_tree.get("parameters/playback").get_current_node() == "Idle":
		#він чогось першу тичку не наносить, а одразу встає в кулдаун ( бо він одразу з руху заходе в кд без тички )
		attack()
	elif !controller.is_target_in_range(controller.attack_range) and !animation_tree.get("parameters/playback").get_current_node() == "Attack":
		move_to_enemy(delta)
	else:
		state_machine.switch_state("idle")
		turn_towards_target()
		


func get_blendspace_animations_count():
	var blend_space = animation_tree.tree_root.get_node("Attack")
	if blend_space is AnimationNodeBlendSpace1D:
		return blend_space.get_blend_point_count()
	else:
		return 1

func get_random_animation_index():
	return randi_range(0, get_blendspace_animations_count() - 1)

func attack():
	if get_blendspace_animations_count() == 1:
		state_machine.switch_state("attack")
		controller.cooldown_timer.start()
	else:
		state_machine.switch_state("attack")
		animation_tree.set("parameters/Attack/blend_position", get_random_animation_index())
		controller.cooldown_timer.start()
	
func move_to_enemy(delta):
	state_machine.switch_state("run")
	var direction = controller.target.global_position.x - character.global_position.x
	var input_direction = 1 if direction > 0 else -1
	handle_movement_patrol(input_direction, delta)

func turn_towards_target() -> void:
	# Порівнюємо позиції персонажа та цілі (героя)
	if controller.target.global_position.x < character.global_position.x and !animation_tree.get("parameters/playback").get_current_node() == "Attack":
		 # Якщо ціль ліворуч від персонажа, персонаж повинен дивитися вліво
		character.transform.x.x = -abs(character.transform.x.x)
	elif controller.target.global_position.x > character.global_position.x and !animation_tree.get("parameters/playback").get_current_node() == "Attack":
		# Якщо ціль праворуч від персонажа, персонаж повинен дивитися вправо
		character.transform.x.x = abs(character.transform.x.x)

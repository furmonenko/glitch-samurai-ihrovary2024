extends State
class_name WidowFirstStageState

var SWITCH_STAGE: StringName = "switch_stage"
# Called when the node enters the scene tree for the first time.
var should_attack: bool = false


func _update(delta):
	if controller.health_component.current_hp <= controller.health_component.max_hp * 0.5:
		state_machine.switch_state("buff")
		await get_tree().create_timer(0.5).timeout
		dispatch(SWITCH_STAGE)
		
		return

	
	if controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped() and animation_tree.get("parameters/playback").get_current_node() == "idle":
		#він чогось першу тичку не наносить, а одразу встає в кулдаун ( бо він одразу з руху заходе в кд без тички )
		attack()
	elif !controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped():
		move_to_enemy(delta)
	else:
		state_machine.switch_state("idle")
		


func get_blendspace_animations_count():
	var blend_space = animation_tree.tree_root.get_node("AttackFirstStage")
	if blend_space is AnimationNodeBlendSpace1D:
		return blend_space.get_blend_point_count()
	else:
		return 1

func get_random_animation_index():
	return randi_range(0, get_blendspace_animations_count() - 1)

func attack():
	state_machine.switch_state("attack")
	animation_tree.set("parameters/AttackFirstStage/blend_position", get_random_animation_index())
	controller.cooldown_timer.start()
	
func move_to_enemy(delta):
	state_machine.switch_state("run")
	var direction = controller.target.global_position.x - character.global_position.x
	var input_direction = 1 if direction > 0 else -1
	handle_movement_patrol(input_direction, delta)

extends State
class_name RunStateAI


# Called when the node enters the scene tree for the first time.
func _enter():
	state_machine.switch_state("run")

func _update(delta):
	run(delta)
	
	if controller.shoot_state and !controller.is_target_in_range(controller.attack_range):
		check_if_on_shoot_position()
	else:
		check_if_on_attack_position()
	

func check_if_on_attack_position():
	if controller.is_target_in_range(controller.attack_range) or !controller.is_target_in_range(controller.spot_range):
		print("controller.is_target_in_range(controller.attack_range)")
		dispatch(EVENT_FINISHED)
		
func check_if_on_shoot_position():
	if controller.is_target_in_range(controller.shoot_range) or !controller.is_target_in_range(controller.spot_range):
		dispatch(EVENT_FINISHED)

func run(delta):
	var direction = controller.target.global_position.x - character.global_position.x
	var input_direction = 1 if direction > 0 else -1
	handle_movement_patrol(input_direction, delta)

extends State
class_name IdleStateAI

# Called when the node enters the scene tree for the first time.
func _enter():
	state_machine.switch_state("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(delta):
	if controller.is_target_in_range(controller.spot_range):
		if controller.shoot_state and !controller.is_target_in_range(controller.attack_range):
			check_if_in_shoot_range()
			check_if_should_move_range()
			return
			
		check_if_in_attack_range()
		check_if_should_move_melee()
		


func check_if_in_attack_range():
	if controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped():
		dispatch(START_ATTACK)

func check_if_in_shoot_range():
	if controller.is_target_in_range(controller.shoot_range) and controller.cooldown_timer.is_stopped():
		dispatch(START_SHOOT)
	
func check_if_should_move_range():
	if !controller.is_target_in_range(controller.attack_range) and !controller.is_target_in_range(controller.shoot_range):
		dispatch(EVENT_FINISHED)
		
func check_if_should_move_melee():
	if !controller.is_target_in_range(controller.attack_range):
		dispatch(EVENT_FINISHED)

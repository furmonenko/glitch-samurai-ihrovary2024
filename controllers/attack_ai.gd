extends State
class_name AttackStateAI


func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)
	
func _enter():
	state_machine.switch_state("attack")
	

func _update(delta):
	pass
	
	
func _on_animation_finished(anim_name: String):
	dispatch(EVENT_FINISHED)
	controller.cooldown_timer.start()
	

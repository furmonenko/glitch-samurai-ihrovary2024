extends State
class_name HitStateAI


func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)
	
# Called when the node enters the scene tree for the first time.
func _enter():
	state_machine.switch_state("got_hit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_animation_finished(anim_name: String):
	if state_machine.current_state == "attack":
		return
	else:
		dispatch(EVENT_FINISHED)

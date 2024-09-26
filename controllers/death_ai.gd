extends State
class_name DeathStateAI

# Called when the node enters the scene tree for the first time.
func _enter():
	state_machine.switch_state("death")

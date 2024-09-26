extends AttackStateAI
class_name ShootStateAI

func _enter() -> void:
	super()
	state_machine.switch_state("shoot")
	

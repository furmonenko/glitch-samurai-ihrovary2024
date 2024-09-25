extends AttackState
class_name ShootState

func _enter() -> void:
	super()
	state_machine.switch_state("shoot")
	# Викликаємо атаку при вході у стан, якщо це необхідно
	attack()
	

extends PlayerState
class_name AttackState

@export var max_combo_attacks: int = 6

var attack_count: int = 0
var current_animation: String = ""  # Поточна анімація

var is_attack_finished :bool

func _enter() -> void:
	# Перехід у стан атаки
	state_machine.switch_state("attack")
	# Викликаємо атаку при вході у стан, якщо це необхідно
	attack()
	
func attack(combo_count: int = 0):
	is_attack_finished = false
	

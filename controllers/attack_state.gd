extends State
class_name AttackState

@export var max_combo_attacks: int = 6

var attack_count: int = 0
var current_animation: String = ""  # Поточна анімація

var is_attack_finished :bool

func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)

func _enter() -> void:
	# Перехід у стан атаки
	state_machine.switch_state("attack")
	# Викликаємо атаку при вході у стан, якщо це необхідно
	attack()
	
func attack():
	is_attack_finished = false
	pass
	
func start_attack():
	pass
	
func _on_animation_finished(animation_name: String) -> void:
	is_attack_finished = true

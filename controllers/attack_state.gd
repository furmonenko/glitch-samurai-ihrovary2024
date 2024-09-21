extends State
class_name AttackState

@export var max_combo_attacks: int = 6
@export var slow_motion_scale: float = 0.2
@export var slow_motion_duration: float = 0.3 

var attack_count: int = 0
var current_animation: String = ""  # Поточна анімація
var attack_pressed_during_animation: bool = false  # Відстежуємо, чи була натиснута кнопка під час анімації

func _ready() -> void:
	super()
	# Підписуємось на завершення анімації
	animation_tree.animation_finished.connect(_on_animation_finished)

func _enter() -> void:
	# Перехід у стан атаки
	state_machine.switch_state("attack")
	# Викликаємо атаку при вході у стан, якщо це необхідно
	attack()
	
func attack():
	pass
	
func start_attack():
	pass
	
func _on_animation_finished(animation_name: String) -> void:
	pass

extends State
class_name AttackState

@export var max_combo_attacks: int = 6
@export var slow_motion_scale: float = 0.2  # Швидкість для слоу-моушн
@export var slow_motion_duration: float = 0.3  # Тривалість слоу-моушн

var attack_count: int = 0
var current_animation: String = ""  # Поточна анімація
var attack_pressed_during_animation: bool = false  # Відстежуємо, чи була натиснута кнопка під час анімації

func _ready() -> void:
	# Підписуємось на завершення анімації
	animation_tree.animation_finished.connect(_on_animation_finished)

func _enter() -> void:
	# Перехід у стан атаки
	state_machine.switch_state(StateMachine.STATE.ATTACK)
	start_attack()

func _update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack_pressed_during_animation = true  # Відзначаємо, що натискали атаку під час анімації
		# Якщо атака ще не закінчена, продовжуємо комбо
		if attack_count < max_combo_attacks:
			attack_count += 1
		else:
			attack_count = 0  # Скидаємо на першу атаку після шостої

		# Продовжуємо атаку
		start_attack()

func start_attack() -> void:
	var current_attack_anim = attack_count % 2
	# Встановлюємо відповідну анімацію в AnimationTree
	if attack_count == 6:
		current_attack_anim = 3
		# Активуємо слоу-моушн для третьої атаки
		# TODO: Активовувати слоу мо тільки коли ми вбили ворога
		# slow_motion_start()

	animation_tree.set("parameters/Attack/blend_position", current_attack_anim)
	attack_pressed_during_animation = false  # Скидаємо стан після запуску нової анімації

func _on_animation_finished(animation_name: String) -> void:
	if attack_pressed_during_animation:
		# Якщо гравець натиснув атаку під час анімації, продовжуємо комбо
		attack_pressed_during_animation = false
	else:
		# Якщо гравець не натиснув атаку, завершуємо стан
		attack_count = 0
		dispatch(EVENT_FINISHED)

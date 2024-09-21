extends AttackState
class_name PlayerAttackState

@export var slow_motion_scale: float = 0.2
@export var slow_motion_duration: float = 0.3 

var attack_pressed_during_animation: bool = false  # Відстежуємо, чи була натиснута кнопка під час анімації

func attack() -> void:
	# Оновлюємо логіку для обробки комбо атак
	attack_pressed_during_animation = true  # Відзначаємо, що атака була викликана

	# Якщо атака ще не закінчена, продовжуємо комбо
	if attack_count < max_combo_attacks:
		attack_count += 1
	else:
		attack_count = 0  # Скидаємо на першу атаку після шостої

	# Починаємо або продовжуємо атаку
	start_attack()

func start_attack() -> void:
	var current_attack_anim = attack_count % 2  # Змінюємо анімації між 0 і 1

	# Для останньої комбо-атаки використовуємо третю анімацію і слоу-мо
	if attack_count == 6:
		current_attack_anim = 3
		# TODO: Активовувати слоу мо тільки коли ми вбили ворога
		# slow_motion_start()

	# Встановлюємо відповідну анімацію в AnimationTree
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

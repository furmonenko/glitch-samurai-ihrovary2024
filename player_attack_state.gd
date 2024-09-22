extends AttackState
class_name PlayerAttackState

var attack_pressed_during_animation: bool = false  # Відстежуємо, чи була натиснута кнопка під час анімації
var combo_count: int

func _enter() -> void:
	state_machine.switch_state("attack")

func start_attack(_combo_count: int) -> void:
	combo_count = _combo_count
	var current_attack_anim = combo_count % 2  # Чередуємо анімації між 0 і 1

	# Якщо це остання комбо-атака (третя в даному випадку), використовуємо спеціальну анімацію
	if combo_count == max_combo_attacks:
		current_attack_anim = 3
		# TODO: Активувати slow motion, якщо це потрібно

	# Встановлюємо відповідну анімацію в AnimationTree
	animation_tree.set("parameters/Attack/blend_position", current_attack_anim)

	# Скидаємо стан після запуску нової анімації
	attack_pressed_during_animation = false

func _on_animation_finished(animation_name: String) -> void:
	if attack_pressed_during_animation:
		# Якщо гравець натиснув атаку під час анімації, продовжуємо комбо
		attack_pressed_during_animation = false
		combo_count += 1  # Переходимо до наступної атаки
		start_attack(combo_count)  # Запускаємо наступну атаку
	else:
		# Якщо гравець не натиснув атаку, завершуємо стан
		dispatch(EVENT_FINISHED)

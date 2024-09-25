extends AIController
class_name ShieldmanController

# Унікальні налаштування для щитовика
@export var shield_cooldown: float = 3.0  # Час після атаки, коли щитовик не рухається

var shield_idle_timer: Timer = Timer.new()  # Таймер, що керує часом після атаки

func _ready() -> void:
	# Додаємо таймер для idle після атаки
	add_child(shield_idle_timer)
	shield_idle_timer.one_shot = true
	shield_idle_timer.wait_time = shield_cooldown
	
	# Викликаємо базовий метод _ready() з AIController
	super._ready()

func handle_states(delta: float) -> void:
	# Викликаємо базовий метод handle_states() з AIController для стандартної поведінки
	super.handle_states(delta)

	# Унікальна логіка для щитовика:
	if state_machine.get_active_state() == attack_state and !shield_idle_timer.is_stopped():
		# Після атаки щитовик залишається на місці
		character.velocity = Vector2.ZERO  # Зупиняємо рух
		if !shield_idle_timer.is_started():
			shield_idle_timer.start()

		if shield_idle_timer.is_stopped():
			state_machine.change_active_state(idle_state)  # Повертаємося до idle після часу очікування

func _on_got_hit(damage_causer) -> void:
	# Специфічна реакція щитовика на удар
	if is_behind_shield(damage_causer):
		state_machine.change_active_state(hit_state)
		$Shieldman/Node2D/Hurt.play()
	else:
		print("Attack blocked by shield") 
		$Shieldman/Node2D/Shield.play()

func is_behind_shield(damage_causer: Node) -> bool:
	# Отримуємо напрямок до ворога
	var direction_to_enemy = (damage_causer.global_position - character.global_position).normalized()
	
	# Вектор, що вказує, куди "дивиться" персонаж, ґрунтуючись на ротації персонажа
	var facing_direction = Vector2(cos(character.global_rotation), sin(character.global_rotation)).normalized()
	
	# Перевіряємо, чи атакуючий позаду щитовика (кут більше 90 градусів)
	return facing_direction.dot(direction_to_enemy) < 0

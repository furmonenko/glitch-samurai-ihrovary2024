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
	super._ready()
	
func _on_got_hit(damage_causer) -> void:
	# Специфічна реакція щитовика на удар
	if is_behind_shield(damage_causer):
		hit_glitch.emit()
		character.animated_sprite.material.set_shader_parameter("is_hurt", true)
		var tween = get_tree().create_tween()
		tween.tween_property(character.animated_sprite.material, "shader_parameter/is_hurt", false, 0.2)
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

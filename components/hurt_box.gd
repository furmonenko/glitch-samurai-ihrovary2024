extends Area2D
class_name Hurtbox

@export var agent: Node2D
@export var health_component: HealthComponent

func _ready() -> void:
	connect("area_entered", on_hurtbox_entered)
	connect("area_exited", on_hurtbox_exited)

func on_hurtbox_entered(area: Area2D):
	if area is HitBox:
		var enemy_hitbox: HitBox = area
		
		# Agent that got hit
		var hit_agent = enemy_hitbox.agent
		
		var enemy_damage_component: DamageComponent = enemy_hitbox.damage_component
		var damage_causer = enemy_damage_component.damage_causer

		# Якщо agent є Shieldman, то перевіряємо, звідки прийшла атака
		if agent is Shieldman:
			if not is_behind_shieldman(damage_causer):
				$"../Node2D/Shield".play()
				print("Attack blocked by Shield!")
				return  # Атака заблокована щитом, не застосовуємо пошкодження

		# Якщо перевірка пройдена, застосовуємо пошкодження
		health_component.apply_damage(enemy_damage_component)

func on_hurtbox_exited(area: Area2D):
	pass

# Перевірка, чи атакуючий знаходиться позаду Shieldman'a
func is_behind_shieldman(damage_causer: Node2D) -> bool:
	# Позиція атакуючого і позиція Shieldman'a
	var shieldman_position = agent.global_position
	var causer_position = damage_causer.global_position
	
	# Отримуємо напрямок, в якому "дивиться" Shieldman
	var shieldman_facing_right = agent.transform.x.x == 1  # Якщо позитивний масштаб по X, то персонаж дивиться направо
	
	# Визначаємо, чи атакуючий позаду
	if shieldman_facing_right:
		# Якщо Shieldman дивиться направо, перевіряємо, чи атакуючий зліва
		return causer_position.x < shieldman_position.x
	else:
		# Якщо Shieldman дивиться наліво, перевіряємо, чи атакуючий справа
		return causer_position.x > shieldman_position.x

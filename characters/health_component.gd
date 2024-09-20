extends Node
class_name HealthComponent

@export var agent :Node2D
@export var max_hp :float = 100.0

@onready var current_hp = max_hp

func apply_damage(damage_component :DamageComponent):
	var damage = damage_component.get_damage_amount()
	var damage_causer = damage_component.get_damage_causer()
	
	current_hp = clampf(current_hp - damage, 0, max_hp)
	
	print(current_hp)
	
	if current_hp <= 0:
		if !agent.has_method("die"):
			return

		agent.call_deferred("die")
		return
	
func heal(heal_amount :float):
	current_hp = clampf(current_hp + heal_amount, current_hp, heal_amount)

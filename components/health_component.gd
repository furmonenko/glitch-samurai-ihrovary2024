extends Node
class_name HealthComponent

signal got_hit(enemy: Character)

@export var agent :Character

var max_hp :float

var current_hp = max_hp

func _ready():
	if agent.stats_resource:
		max_hp = agent.stats_resource.max_hp
		
	current_hp = max_hp

func apply_damage(damage_component :DamageComponent):
	var damage =  damage_component.get_damage_amount()
	var damage_causer = damage_component.get_damage_causer()
	
	if agent.is_glitched:
		return
	
	agent.direction_to_enemy = agent.global_position.direction_to(damage_causer.global_position)
	
	current_hp = clampf(current_hp - damage, 0, max_hp)
	
	got_hit.emit(damage_causer)
	
	if current_hp <= 0:
		Helpers.slow_motion_start(0.2, 0.2)
		
		if !agent.has_signal("died"):
			return

		agent.died.emit(agent)
		return

func heal(heal_amount :float):
	current_hp = clampf(current_hp + heal_amount, current_hp, heal_amount)

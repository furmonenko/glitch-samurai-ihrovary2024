extends Area2D
class_name Hurtbox

@export var agent :Node2D
@export var health_component :HealthComponent

func _ready() -> void:
	connect("area_entered", on_hurtbox_entered)
	connect("area_exited", on_hurtbox_exited)

func on_hurtbox_entered(area :Area2D):
	if area is HitBox:
		var enemy_hitbox :HitBox = area
		
		# Agent that got hit
		var hit_agent = enemy_hitbox.agent
		
		var enemy_damage_copmonent :DamageComponent = enemy_hitbox.damage_component
		health_component.apply_damage(enemy_damage_copmonent)

func on_hurtbox_exited(area :Area2D):
	pass

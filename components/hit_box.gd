extends Area2D
class_name HitBox

signal hit_target(damaged_character: Character)

@export var agent :Node2D
@export var damage_component :DamageComponent

func _on_hitbox_entered(area: Area2D):
	if area is Hurtbox && area.agent:
		hit_target.emit(area.agent)


func _on_hitbox_exited(area):
	pass # Replace with function body.

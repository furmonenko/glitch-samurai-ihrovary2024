extends Area2D
class_name HitBox

signal hit_target(damaged_character: Character)

@export var agent :Node2D
@export var damage_component :DamageComponent

func _ready() -> void:
	connect("area_entered", on_hitbox_entered)
	connect("area_exited", on_hitbox_exited)

func on_hitbox_entered(area :Hurtbox):
	if area is Hurtbox && area.agent:
		hit_target.emit(area.agent)

func on_hitbox_exited(area :Area2D):
	pass

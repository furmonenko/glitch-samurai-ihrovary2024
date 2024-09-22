extends Area2D
class_name HitBox

signal hit_target()

@export var agent :Node2D
@export var damage_component :DamageComponent

func _ready() -> void:
	connect("area_entered", on_hitbox_entered)
	connect("area_exited", on_hitbox_exited)

func on_hitbox_entered(area :Hurtbox):
	hit_target.emit()

func on_hitbox_exited(area :Area2D):
	pass

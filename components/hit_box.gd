extends Area2D
class_name HitBox

signal hit_target(damaged_character: Character)

@export var agent :Node2D
@export var damage_component :DamageComponent

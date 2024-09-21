extends Node
class_name DamageComponent

@export var damage_causer :Node2D
@export var damage_amount :float = 20.0

func get_damage_amount():
	return damage_amount

func get_damage_causer():
	return damage_causer

extends Node
class_name DamageComponent

@export var damage_causer :Node2D

var damage_amount

func _ready():
	if damage_causer.stats_resource:
		damage_amount = damage_causer.stats_resource.damage

func get_damage_amount():
	return damage_amount

func get_damage_causer():
	return damage_causer

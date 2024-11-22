extends Control
class_name DamageNumbers

@onready var damage_amount = $SubViewport/DamageAmount
@onready var damage_particle = $DamageParticle

func _ready():
	%SubViewport.size.x = damage_amount.get_minimum_size().x

extends CharacterBody2D
class_name Character

@export var hitbox: HitBox

signal died(character :Character)

var direction_to_enemy: Vector2
var is_dead :bool = false

func get_anim_tree():
	return %AnimationTree
	
func apply_knockback(direction: Vector2, force: float = 400):
	var knockback_velocity = direction.normalized() * force
	velocity += knockback_velocity

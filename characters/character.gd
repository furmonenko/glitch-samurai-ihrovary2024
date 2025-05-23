extends CharacterBody2D
class_name Character

@onready var animated_sprite = $AnimatedSprite2D
@onready var alert_point = %AlertPoint


@export var hitbox: HitBox

var is_glitched :bool = false

signal died(character :Character)

var direction_to_enemy: Vector2
var is_dead :bool = false

func get_anim_tree():
	return %AnimationTree
	
func apply_knockback(direction: Vector2, force: float = 400):
	var knockback_velocity = direction.normalized() * force
	velocity += knockback_velocity

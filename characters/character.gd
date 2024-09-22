extends CharacterBody2D
class_name Character

signal died(character :Character)

var is_dead :bool = false

func get_anim_tree():
	return %AnimationTree
	

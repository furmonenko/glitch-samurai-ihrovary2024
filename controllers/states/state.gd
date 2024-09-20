extends LimboState
class_name State

@export var animation_tree: AnimationTree
@export var state_machine :StateMachine
@export var state_enum: StateMachine.STATE = StateMachine.STATE.DEFAULT
@export var character :CharacterBody2D

@onready var playback :AnimationNodeStateMachinePlayback

func _ready() -> void:
	# if !state_enum:
		# Helpers.throw_error("No state enum in ", name)
	if !animation_tree:
		Helpers.throw_error("No animation tree in ", name)
		
	if get_parent() is StateMachine:
		state_machine = get_parent()
		
	if !state_machine:
		Helpers.throw_error("No state machine in ", name)
		
	playback = animation_tree["parameters/playback"]

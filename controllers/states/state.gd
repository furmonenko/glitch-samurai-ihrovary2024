extends LimboState
class_name State

@export var animation_tree: AnimationTree
@export var state_machine :StateMachine
@export var character :CharacterBody2D
@export var animation_name :String

@onready var playback :AnimationNodeStateMachinePlayback

func _ready():
	pass

func initialize_state():
	if !animation_tree:
		Helpers.throw_error("No animation tree in ", name)
		
	if get_parent() is StateMachine:
		state_machine = get_parent()
		
	if !state_machine:
		Helpers.throw_error("No state machine in ", name)
		
	playback = animation_tree["parameters/playback"]

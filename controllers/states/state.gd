extends LimboState
class_name State

@export var animation_tree: AnimationTree
@export var state_machine :StateMachine
@export var character :CharacterBody2D
@export var controller: Controller

@onready var playback :AnimationNodeStateMachinePlayback

@export_category("Move Stats")
@export var speed: float = 30.0
@export var acceleration: float = 1.0
@export var deceleration: float = 1.0
@export var max_speed: float = 50.0

var velocity :Vector2

var START_ATTACK :StringName = "start_attack"
var START_SHOOT :StringName = "start_shoot"

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

func handle_movement(input_direction: int, delta: float) -> void:
	# Якщо персонаж змінює напрямок, обнуляємо швидкість
	if (input_direction > 0 and velocity.x < 0) or (input_direction < 0 and velocity.x > 0):
		velocity.x = 0

	# Оброт персонажа на основі напрямку
	if input_direction != 0:
		if character is Shieldman:
			await get_tree().create_timer(0.5).timeout
			
		if input_direction > 0:
			character.transform.x.x = 1
		elif input_direction < 0:
			character.transform.x.x = -1

		# Прискорення при русі
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration)
	else:
		# Децелерація при зупинці
		velocity.x = move_toward(velocity.x, 0, deceleration)

	# Якщо швидкість близька до нуля, вважаємо, що персонаж зупинився
	if abs(velocity.x) < 0.1:
		velocity.x = 0
		dispatch(EVENT_FINISHED)

	# Переміщення персонажа і застосування гравітації
	character.velocity = velocity
	character.move_and_slide()

func handle_movement_patrol(input_direction: int, delta: float) -> void:
	# Якщо персонаж змінює напрямок, обнуляємо швидкість
	if (input_direction > 0 and velocity.x < 0) or (input_direction < 0 and velocity.x > 0):
		velocity.x = 0

	# Оброт персонажа на основі напрямку
	if input_direction != 0:		
		if input_direction > 0:
			character.transform.x.x = 1
		elif input_direction < 0:
			character.transform.x.x = -1

		# Прискорення при русі
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration)


	# Переміщення персонажа і застосування гравітації
	character.velocity = velocity
	character.move_and_slide()

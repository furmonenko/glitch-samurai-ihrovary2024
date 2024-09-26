extends State
class_name RunStateAI

@export var speed: float = 30.0
@export var acceleration: float = 1.0
@export var deceleration: float = 1.0
@export var max_speed: float = 50.0

var velocity :Vector2
# Called when the node enters the scene tree for the first time.
func _enter():
	state_machine.switch_state("run")

func _update(delta):
	var direction = controller.target.global_position.x - character.global_position.x
	var input_direction = 1 if direction > 0 else -1
	handle_movement(input_direction, delta)
	
	if controller.shoot_state and !controller.is_target_in_range(controller.attack_range):
		check_if_on_shoot_position()
	else:
		check_if_on_attack_position()
	

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

func check_if_on_attack_position():
	if controller.is_target_in_range(controller.attack_range) or !controller.is_target_in_range(controller.spot_range):
		dispatch(EVENT_FINISHED)
		
func check_if_on_shoot_position():
	if controller.is_target_in_range(controller.shoot_range) or !controller.is_target_in_range(controller.spot_range):
		dispatch(EVENT_FINISHED)

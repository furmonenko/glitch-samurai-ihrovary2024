extends PlayerState
class_name GlitchState

@export var player_controller: PlayerController
@onready var idle_state: IdleState = %Idle
@onready var glitch_time: float = 0.2
@onready var glitch_active: bool = false  # Чи активний зараз глітч

@export var scene_glitch: GlitchEffect




var walls_to_ignore = ["WallType1", "WallType2"]  # Назви типів стін, через які персонаж може проходити

func _enter() -> void:
	state_machine.switch_state("glitch")
	character.set_collision_mask_value(4, false)
	
	scene_glitch.animation_player.play("player_glitched")
	scene_glitch.glitch.visible = true
	
	character.velocity.y -= 100
	character.move_and_slide()
	character.is_glitched = true
	glitch_time = randf_range(0.1, 0.3)  # Встановлюємо випадковий інтервал для першого ривка

func _exit() -> void:
	player_controller.glitch_exited.emit()
	character.set_collision_mask_value(4, true)
	
	scene_glitch.animation_player.stop()
	scene_glitch.glitch.visible = false
	scene_glitch.glitch_sound.playing = false
	
	character.is_glitched = false

# Функція для обробки вільного руху з ефектом глітча
func handle_glitch_movement(delta: float) -> void:
	# Відлік до наступного ривка або паузи
	glitch_time -= delta

	if glitch_time <= 0:
		if glitch_active:
			# Якщо був активний ривок, переходимо в паузу
			glitch_active = false
			glitch_time = character.stats_resource.glitch_pause_time
		else:
			# Якщо був період паузи, робимо ривок
			glitch_active = true
			glitch_time = character.stats_resource.glitch_duration

	# Тільки під час активного ривка рухаємо персонажа
	if glitch_active:
		var input_vector = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()

		if input_vector != Vector2.ZERO:
			# Під час ривка збільшуємо швидкість різко
			velocity = velocity.move_toward(input_vector * character.stats_resource.glitch_move_speed, character.stats_resource.glitch_acceleration * delta)
		else:
			# Якщо гравець не рухається, зменшуємо швидкість
			velocity = velocity.move_toward(Vector2.ZERO, character.stats_resource.glitch_deceleration * delta)
	else:
		# Під час паузи швидкість падає до нуля
		velocity = Vector2.ZERO

	# Переміщення персонажа
	character.velocity = velocity
	character.move_and_slide()

	# Ігнорування стін
	for wall in get_tree().get_nodes_in_group("walls"):
		if wall.name in walls_to_ignore:
			wall.set_deferred("collision_layer", 0)  # Вимикаємо колізію з певними стінами

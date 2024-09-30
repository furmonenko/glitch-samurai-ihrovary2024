extends FirstStageState
class_name SecondStageState

@export var landing_time: float = 2.0
@export var jump_cooldown: float = 7.0

var is_about_to_jump: bool = false

var landing_timer = Timer.new()
var jump_cooldown_timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)

func _enter():
	init_timers()
	jump_cooldown_timer.start()

func _update(delta):
	if is_about_to_jump:
		return
	elif controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped():
		attack()
	elif controller.is_target_in_range(controller.spot_range) and !controller.is_target_in_range(controller.attack_range):
		move_to_enemy(delta)
	else:
		state_machine.switch_state("idle")

func init_timers():
	# Ініціалізація таймера очікування
	landing_timer = Timer.new()
	landing_timer.wait_time = landing_time
	landing_timer.one_shot = true
	add_child(landing_timer)
	landing_timer.timeout.connect(_on_landing_timeout)

	# Ініціалізація таймера патрулювання
	jump_cooldown_timer = Timer.new()
	jump_cooldown_timer.wait_time = jump_cooldown
	jump_cooldown_timer.one_shot = true
	add_child(jump_cooldown_timer)
	jump_cooldown_timer.timeout.connect(_on_jump_cooldown_timeout)

func _on_animation_finished(anim_name: String):
	if anim_name == "jump":
		controller.visible = false
	
	if anim_name == "landing":
		state_machine.switch_state("idle")

func _on_jump_cooldown_timeout():
	is_about_to_jump = true
	jump()
	
func _on_landing_timeout():
	land()
	is_about_to_jump = false

func jump():
	animation_tree.set("parameters/AttackSecondStage/blend_position", 0)
	landing_timer.start()
	state_machine.switch_state("attack_strong")
	

func land():
	controller.global_position = controller.target.global_position
	animation_tree.set("parameters/AttackSecondStage/blend_position", 1)
	jump_cooldown_timer.start()
	controller.visible = true
	state_machine.switch_state("attack_strong")
	

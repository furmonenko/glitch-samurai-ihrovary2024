extends WidowFirstStageState
class_name WidowSecondStageState

@export var landing_time: float = 4.0
@export var jump_cooldown: float = 7.0
@export var updated_cooldown: float = 1.5

var is_about_to_jump: bool = false

var landing_timer = Timer.new()
var jump_cooldown_timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func initialize_state():
	super()
	animation_tree.animation_finished.connect(_on_animation_finished)

func _enter():
	init_timers()
	
	jump()
	
	controller.cooldown_timer.wait_time = updated_cooldown

func _update(delta):
	if is_about_to_jump:
		return
	elif controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped() and animation_tree.get("parameters/playback").get_current_node() == "idle":
		#він чогось першу тичку не наносить, а одразу встає в кулдаун ( бо він одразу з руху заходе в кд без тички )
		turn_towards_target()
		attack()
	elif !controller.is_target_in_range(controller.attack_range) and controller.cooldown_timer.is_stopped():
		move_to_enemy(delta)
	else:
		state_machine.switch_state("idle")
		turn_towards_target()

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
		character.visible = false
	
	if anim_name == "landing":
		is_about_to_jump = false
		

func _on_jump_cooldown_timeout():
	if animation_tree.get("parameters/playback").get_current_node() == "AttackFirstStage":
		await get_tree().create_timer(0.8).timeout
	jump()
	
func _on_landing_timeout():
	land()
	

func jump():
	is_about_to_jump = true
	
	state_machine.switch_state("jumping")
	
	landing_timer.start() 
	

func land():
	character.global_position = controller.target.global_position
	
	state_machine.switch_state("landing")
	
	jump_cooldown_timer.start()
	character.visible = true
	

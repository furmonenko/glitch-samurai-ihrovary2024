extends Controller
class_name BossController

signal hit_glitch
signal boss_death
# Налаштування для бота
var spot_range: float = 100.0  # Дальність, на якій бот бачить ворога
var attack_range: float = 20.0  # Дальність атаки
var cooldown_duration: float = 0.5  # Кулдаун атаки

@export var health_component: HealthComponent

@export var death_state: DeathStateAI
@export var patrol_state: PatrolState
@export var first_stage_state: WidowFirstStageState
@export var second_stage_state: WidowSecondStageState

@export var run_sound: AudioStreamPlayer2D

@onready var hurt_box_collision = $BossWidow/CollisionShape2D/Hurtbox/CollisionShape2D
@onready var hp_bar = $CanvasLayer/VBoxContainer/TextureProgressBar
@onready var canvas_layer = $CanvasLayer


var target: Character = null  # Ворог, на якого бот націлюється
var cooldown_timer: Timer = Timer.new()  # Таймер для кулдауна атаки
var last_state: State = null  # Останній стан перед отриманням удару

signal character_is_behind

func _ready() -> void:
	init_stats()
	
	hp_bar.max_value = health_component.max_hp
	hp_bar.value = health_component.max_hp
	
	canvas_layer.visible = false
	# Додаємо таймер для кулдауна атаки
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_duration
	
	character.died.connect(func(character):
		character_died.call_deferred()
		state_machine.dispatch(state_machine.CHARACTER_DIED)
		boss_death.emit()
		)
		
		
	health_component.got_hit.connect(_on_got_hit)
	
	_init_state_machine()

func _process(delta):
	super(delta)
	if is_target_in_range(spot_range + 100.0):
		canvas_layer.visible = true
	
func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(state_machine.ANYSTATE, death_state, state_machine.CHARACTER_DIED)
	state_machine.add_transition(patrol_state, first_stage_state, patrol_state.SWITCH_STAGE)
	state_machine.add_transition(first_stage_state, second_stage_state, first_stage_state.SWITCH_STAGE)
	
	state_machine.add_transition(first_stage_state, patrol_state, first_stage_state.EVENT_FINISHED)
	


var direction_to_enemy: Vector2

func _on_got_hit(damage_causer) -> void:
	direction_to_enemy = character.global_position.direction_to(damage_causer.global_position)
	hit_glitch.emit()
	%HitSound.play()
	hp_bar.value = health_component.current_hp
	character.animated_sprite.material.set_shader_parameter("is_hurt", true)
	var tween = get_tree().create_tween()
	tween.tween_property(character.animated_sprite.material, "shader_parameter/is_hurt", false, 0.2)

func character_died():
	
	character.is_dead = true
	hurt_box_collision.disabled = true


func handle_states(delta: float) -> void:
	super(delta)
	if !state_machine.is_active():
		return
		
	if not target:
		find_target()  # Якщо цілі немає, шукаємо ворог
	
func find_target() -> void:
	# Ти можеш використовувати свою логіку для пошуку ворога. Наприклад, використовуй зону або отримуй список ворогів
	for enemy in get_tree().get_nodes_in_group("player"):
		if is_instance_valid(enemy) and not enemy.is_dead and not enemy.is_glitched:
			target = enemy
			break

func is_target_in_range(range: float) -> bool:
	# Перевіряємо, чи ворог в межах заданої відстані
	if target:
		return character.global_position.distance_to(target.global_position) <= range
	return false

func step_sound():
	run_sound.play()

func init_stats():
	spot_range = character.stats_resource.spot_range
	attack_range = character.stats_resource.attack_range
	cooldown_duration = character.stats_resource.attack_speed

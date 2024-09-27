extends Controller
class_name AIController

signal hit_glitch
# Налаштування для бота
@export var spot_range: float = 100.0  # Дальність, на якій бот бачить ворога
@export var attack_range: float = 20.0  # Дальність атаки
@export var cooldown_duration: float = 0.5  # Кулдаун атаки

@export var shoot_state: ShootStateAI
@export var idle_state: IdleStateAI
@export var run_state: RunStateAI
@export var attack_state: AttackStateAI
@export var health_component: HealthComponent
@export var death_state: DeathStateAI
@export var hurt_box_collision: CollisionShape2D

@export var attack_sound: AudioStreamPlayer2D
@export var hit_sound: AudioStreamPlayer2D

var target: Character = null  # Ворог, на якого бот націлюється
var cooldown_timer: Timer = Timer.new()  # Таймер для кулдауна атаки
var last_state: State = null  # Останній стан перед отриманням удару

func _ready() -> void:
	# Додаємо таймер для кулдауна атаки
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_duration
	
	character.died.connect(func(character):
		character_died.call_deferred()
		state_machine.dispatch(state_machine.CHARACTER_DIED)
		)
		
		
	health_component.got_hit.connect(_on_got_hit)
	
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(state_machine.ANYSTATE, death_state, state_machine.CHARACTER_DIED)
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	
	state_machine.add_transition(idle_state, attack_state, idle_state.START_ATTACK)
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	


var direction_to_enemy: Vector2

func _on_got_hit(damage_causer) -> void:
	direction_to_enemy = character.global_position.direction_to(damage_causer.global_position)
	hit_sound.play()
	hit_glitch.emit()
	character.animated_sprite.material.set_shader_parameter("is_hurt", true)
	var tween = get_tree().create_tween()
	tween.tween_property(character.animated_sprite.material, "shader_parameter/is_hurt", false, 0.2)

func character_died():
	if hit_sound:
		hit_sound.play()
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

extends Controller
class_name HellbotController

# Налаштування для бота
@export var spot_range: float = 100.0  # Дальність, на якій бот бачить ворога
@export var attack_range: float = 20.0  # Дальність атаки
@export var cooldown_duration: float = 2.0  # Кулдаун атаки

@onready var idle_state: IdleState = $HellBot/LimboHSM/Idle
@onready var run_state: RunState = $HellBot/LimboHSM/Run
@onready var attack_state: HellbotAttackState = $HellBot/LimboHSM/Attack

var target: Character = null  # Ворог, на якого бот націлюється
var cooldown_timer: Timer = Timer.new()  # Таймер для кулдауна атаки

func _ready() -> void:
	# Додаємо таймер для кулдауна атаки
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_duration
	
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)

func handle_states(delta: float) -> void:
	super(delta)
	
	if not target:
		find_target()  # Якщо цілі немає, шукаємо ворога

	# Перевірка на стан кулдауна
	if cooldown_timer.is_stopped():
		if target and is_target_in_range(spot_range):
			# Якщо ворог в зоні видимості, йдемо до нього
			if not is_target_in_range(attack_range):
				# Переходимо в стан бігу
				if state_machine.get_active_state() != run_state:
					state_machine.change_active_state(run_state)
				else:
					move_to_target(delta)
			else:
				# Якщо ворог у зоні атаки, атакуємо
				if state_machine.get_active_state() != attack_state:
					state_machine.change_active_state(attack_state)
				elif attack_state.is_attack_finished:  # Перевірка, чи завершилася атака
					# Після атаки чекаємо на кулдаун
					cooldown_timer.start()
					state_machine.change_active_state(idle_state)
		else:
			# Якщо ворог вийшов із зони видимості, повертаємося до Idle
			state_machine.change_active_state(idle_state)

func find_target() -> void:
	# Ти можеш використовувати свою логіку для пошуку ворога. Наприклад, використовуй зону або отримуй список ворогів
	for enemy in get_tree().get_nodes_in_group("player"):
		if is_instance_valid(enemy) and not enemy.is_dead:
			target = enemy
			break

func is_target_in_range(range: float) -> bool:
	# Перевіряємо, чи ворог в межах заданої відстані
	if target:
		return character.global_position.distance_to(target.global_position) <= range
	return false

func move_to_target(delta: float) -> void:
	# Рухаємося до ворога
	if target:
		var direction = (target.global_position - character.global_position).normalized()
		run_state.handle_movement(sign(direction.x), delta)

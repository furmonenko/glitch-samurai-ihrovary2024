extends AIController
class_name PickemanController

# Налаштування для бота
@export var spot_range: float = 100.0  # Дальність, на якій бот бачить ворога
@export var attack_range: float = 20.0  # Дальність атаки
@export var cooldown_duration: float = 1.0  # Кулдаун атаки

@onready var idle_state = $Pickeman/LimboHSM/Idle
@onready var run_state = $Pickeman/LimboHSM/Run
@onready var attack_state = $Pickeman/LimboHSM/Attack
@onready var hit_state = $Pickeman/LimboHSM/Hit
@onready var death_state = $Pickeman/LimboHSM/Death
@onready var health_component = $Pickeman/HealthComponent

var target: Character = null  # Ворог, на якого бот націлюється
var cooldown_timer: Timer = Timer.new()  # Таймер для кулдауна атаки
var last_state: State = null  # Останній стан перед отриманням удару

func _ready() -> void:
	# Додаємо таймер для кулдауна атаки
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_duration
	
	character.died.connect(func(character):
		character.is_dead = true
		)
	health_component.got_hit.connect(_on_got_hit)
	
	_init_state_machine()

func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(idle_state, run_state, idle_state.EVENT_FINISHED)
	state_machine.add_transition(run_state, idle_state, run_state.EVENT_FINISHED)
	state_machine.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	state_machine.add_transition(hit_state, idle_state, hit_state.EVENT_FINISHED)

func _on_got_hit(damage_causer) -> void:
	state_machine.change_active_state(hit_state)

func handle_states(delta: float) -> void:
	super(delta)
	if !state_machine.is_active():
		return
	
	if state_machine.get_active_state() != death_state and character.is_dead:
		state_machine.change_active_state(death_state)
		return
		
	if state_machine.get_active_state() == hit_state or character.is_dead:
		return
		
	if state_machine.get_active_state() == attack_state:
		return
		
	if not target:
		find_target()  # Якщо цілі немає, шукаємо ворога

	if target and is_target_in_range(spot_range):
		# Якщо ворог в зоні видимості, йдемо до нього
		if not is_target_in_range(attack_range):
			# Переходимо в стан бігу
			if state_machine.get_active_state() != run_state and state_machine.get_active_state() != attack_state:
				state_machine.change_active_state(run_state)
			else:
				# Визначаємо напрямок до ворога
				var direction = target.global_position.x - character.global_position.x
				var input_direction = 1 if direction > 0 else -1
				# Викликаємо handle_movement з RunState для обробки руху в потрібному напрямку
				run_state.handle_movement(input_direction, delta)
		else:
			# Якщо ворог вийшов із зони видимості, повертаємося до Idle
			state_machine.change_active_state(idle_state)
		# Перевірка на стан кулдауна
		if cooldown_timer.is_stopped() and is_target_in_range(attack_range):
			character.velocity = Vector2.ZERO
				# Якщо ворог у зоні атаки, атакуємо
			if state_machine.get_active_state() != attack_state and !attack_state.is_attack_finished:
				print(attack_state.is_attack_finished)
				state_machine.change_active_state(attack_state)
			elif attack_state.is_attack_finished:  # Перевірка, чи завершилася атака
				print(attack_state.is_attack_finished)
				# Після атаки чекаємо на кулдаун
				state_machine.change_active_state(idle_state)
				cooldown_timer.start()
			attack_state.is_attack_finished = false

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

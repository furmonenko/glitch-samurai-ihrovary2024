extends AIController
class_name ShieldmanController

# Налаштування для бота
@export var spot_range: float = 100.0  # Дальність, на якій бот бачить ворога
@export var attack_range: float = 20.0  # Дальність атаки
@export var cooldown_duration: float = 0.2  # Тривалість перебування в idle після атаки

@onready var hit_state: HitState = $Shieldman/LimboHSM/Hit
@onready var idle_state: IdleState = $Shieldman/LimboHSM/Idle
@onready var run_state: RunState = $Shieldman/LimboHSM/Run
@onready var attack_state: AttackState = $Shieldman/LimboHSM/Attack
@onready var health_component: HealthComponent = $Shieldman/HealthComponent
@onready var death_state: DeathState = $Shieldman/LimboHSM/Death

var target: Character = null  # Ворог, на якого бот націлюється
var cooldown_timer: Timer = Timer.new()  # Таймер для періоду після атаки
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
	$Shieldman/Node2D/Hurt.play()
	state_machine.change_active_state(hit_state)

func handle_states(delta: float) -> void:
	super(delta)

	
	if !state_machine.is_active():
		print("State machine is inactive")
		return
	
	if state_machine.get_active_state() != death_state and character.is_dead:
		state_machine.change_active_state(death_state)
		return
	if character.is_dead and state_machine.get_active_state() == death_state:
		await get_tree().create_timer(1).timeout
		queue_free()
		return
		
	if state_machine.get_active_state() == hit_state:
		print("In hit state, skipping further checks")
		return
		
	if state_machine.get_active_state() == attack_state:
		print("In attack state, skipping further checks")
		return
		
	if not target:
		print("No target, searching for one...")
		find_target()

	if target:
		# Якщо ціль перебуває в глітч-стані, ворог має зупинитися
		if target.is_glitched:
			print("Target is glitched, transitioning to idle")
			state_machine.change_active_state(idle_state)
			target = null  # Забуваємо ціль
			return

		# Якщо ворог у зоні видимості та не в глітчі, ворог намагається переслідувати або атакувати
		if is_target_in_range(spot_range):
			print("Target is in spot range")
			# Якщо ворог в зоні видимості, йдемо до нього
			if not is_target_in_range(attack_range):
				print("Target is not in attack range, transitioning to run state")
				# Переходимо в стан бігу
				if state_machine.get_active_state() != run_state and state_machine.get_active_state() != attack_state:
					state_machine.change_active_state(run_state)
				else:
					# Визначаємо напрямок до ворога
					var direction = target.global_position.x - character.global_position.x
					var input_direction = 1 if direction > 0 else -1
					print("Running towards target, direction: " + str(input_direction))
					# Викликаємо handle_movement з RunState для обробки руху в потрібному напрямку
					run_state.handle_movement(input_direction, delta)
			else:
				# Якщо ворог у зоні атаки
				if cooldown_timer.is_stopped() and is_target_in_range(attack_range):
					character.velocity = Vector2.ZERO  # Зупиняємо рух
					print("Target in attack range, preparing to attack")
					if state_machine.get_active_state() != attack_state and !attack_state.is_attack_finished:
						print("Starting attack state")
						state_machine.change_active_state(attack_state)
						await get_tree().create_timer(0.75).timeout
						
						$Shieldman/Node2D/Attack.play()
					elif attack_state.is_attack_finished:  # Перевірка, чи завершилася атака
						print("Attack finished, transitioning to idle state")
						# Після атаки чекаємо на кулдаун
						state_machine.change_active_state(idle_state)
						cooldown_timer.start()
					attack_state.is_attack_finished = false
		else:
			# Якщо ворог вийшов із зони видимості, повертаємося до Idle
			print("Target is out of spot range, transitioning to idle state")
			state_machine.change_active_state(idle_state)

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

func move_to_target(delta: float) -> void:
	# Рухаємося до ворога
	if target:
		var direction = (target.global_position - character.global_position).normalized()
		run_state.handle_movement(sign(direction.x), delta)

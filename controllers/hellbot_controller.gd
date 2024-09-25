extends AIController
class_name HellbotController

@export var shoot_range: float = 80.0

@onready var shoot_state = $HellBot/LimboHSM/Shoot


func _init_state_machine() -> void:
	super()
	
	state_machine.add_transition(shoot_state, idle_state, shoot_state.EVENT_FINISHED)

func handle_states(delta: float) -> void:
	if !state_machine.is_active():
		return
	
	if state_machine.get_active_state() != death_state and character.is_dead:
		state_machine.change_active_state(death_state)
		return
		
	if state_machine.get_active_state() == hit_state or character.is_dead:
		return
		
	if state_machine.get_active_state() == attack_state or state_machine.get_active_state() == shoot_state:
		return
		
	if not target:
		find_target()  # Якщо цілі немає, шукаємо ворога
	
	if target:
		# Якщо ціль перебуває в глітч-стані, ворог має зупинитися
		if target.is_glitched:
			state_machine.change_active_state(idle_state)
			target = null  # Забуваємо ціль
			return

		# Якщо ворог у зоні видимості та не в глітчі, ворог намагається переслідувати або атакувати
		if is_target_in_range(spot_range):
			# Якщо ворог в зоні видимості, йдемо до нього
			if not is_target_in_range(shoot_range):
				# Переходимо в стан бігу
				if state_machine.get_active_state() != run_state and (state_machine.get_active_state() != shoot_state and state_machine.get_active_state() != attack_state):
					state_machine.change_active_state(run_state)
				elif state_machine.get_active_state() == run_state:
					# Визначаємо напрямок до ворога
					var direction = target.global_position.x - character.global_position.x
					var input_direction = 1 if direction > 0 else -1
					# Викликаємо handle_movement з RunState для обробки руху в потрібному напрямку
					run_state.handle_movement(input_direction, delta)
			else:
				# Якщо ворог в зоні атаки
				if is_target_in_range(attack_range):
					if cooldown_timer.is_stopped() and is_target_in_range(attack_range):
						if state_machine.get_active_state() != attack_state and !attack_state.is_attack_finished:
							state_machine.change_active_state(attack_state)
						elif attack_state.is_attack_finished:  # Перевірка, чи завершилася атака
							# Після атаки чекаємо на кулдаун
							state_machine.change_active_state(idle_state)
							cooldown_timer.start()
						attack_state.is_attack_finished = false
						
				elif is_target_in_range(shoot_range):
					if cooldown_timer.is_stopped() and is_target_in_range(shoot_range):
						if state_machine.get_active_state() != shoot_state and !shoot_state.is_attack_finished:
							state_machine.change_active_state(shoot_state)
						elif shoot_state.is_attack_finished:  # Перевірка, чи завершилася атака
							# Після атаки чекаємо на кулдаун
							state_machine.change_active_state(idle_state)
							cooldown_timer.start()
						shoot_state.is_attack_finished = false
		else:
			# Якщо ворог вийшов із зони видимості, повертаємося до Idle
			state_machine.change_active_state(idle_state)

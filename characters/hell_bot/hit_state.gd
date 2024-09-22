extends State
class_name HitState

var hit_duration: float = 0.5  # Тривалість стану отримання удару
var hit_timer: Timer = Timer.new()  # Таймер для завершення стану удару

func initialize_state() -> void:
	super()
	animation_tree.animation_finished.connect(_on_hit_finished)

func _enter() -> void:
	state_machine.switch_state("got_hit")

func _on_hit_finished(anim_name) -> void:
	# Завершуємо стан удару і повідомляємо стейт машину
	if state_machine.get_active_state() != null:
		dispatch(EVENT_FINISHED)

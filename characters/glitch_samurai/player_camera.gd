extends Camera2D

var shake_intensity = 1.5 # Інтенсивність трясу
var shake_duration = 0.2  # Тривалість трясу
var shake_timer = 0.0
var original_offset = Vector2.ZERO  # Початковий зсув камери

func _ready() -> void:
	original_offset = offset 

# Викликайте цю функцію для запуску ефекту трясіння
func start_screen_shake():
	shake_timer = shake_duration  # Запускаємо таймер трясіння

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		# Генеруємо випадковий зсув для ефекту трясіння
		var shake_offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		offset = original_offset + shake_offset  # Додаємо зсув до поточного offset
	else:
		# Відновлюємо початковий offset після завершення трясіння
		offset = original_offset

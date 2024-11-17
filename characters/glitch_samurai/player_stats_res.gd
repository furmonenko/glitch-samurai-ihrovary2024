extends Resource
class_name PlayerStatsResource

@export_category("Main Stats")
@export var max_hp: float = 100.0
@export var hp_decrease_rate: float = 10

@export_category("Combat Stats")
@export var attack_speed: float = 0.5
@export var damage: float = 20.0
@export var crit_chance: float = 0.0
@export var crit_multiplier: float = 0.0

@export_category("Ground Movement Stats")
@export var max_speed: float = 100.0
@export var acceleration: float = 20.0
@export var deceleration: float = 100.0

@export_category("Air Movement Stats")
@export var jump_force: float = 600.0
@export var gravity: float = 50.0
@export var max_air_speed: float = 150.0
@export var max_fall_speed: float = 300.0  # Максимальна швидкість падіння

@export_category("Glitch Movement Stats")
@export var glitch_move_speed: float = 500.0  # Максимальна швидкість пересування
@export var glitch_pause_time: float = 0.1  # Тривалість паузи між ривками
@export var glitch_duration: float = 0.2  # Тривалість самого ривка
@export var glitch_acceleration: float = 50.0
@export var glitch_deceleration: float = 100.0

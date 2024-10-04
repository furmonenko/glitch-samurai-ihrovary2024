extends Node2D

@onready var checkpoint = $Checkpoint
@onready var boss_barier = $Barriers/BossFight/CollisionShape2D
@onready var boss_widow_controller = $BossWidowController


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.start_event.connect(start_fight)

func _process(delta):
	if boss_widow_controller == null:
		boss_barier.call_deferred("set_disabled", true)

func start_fight():
	boss_barier.call_deferred("set_disabled", false)

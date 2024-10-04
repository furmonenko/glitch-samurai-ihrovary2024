extends Node2D

@onready var checkpoint = $CheckpointBossFight
@onready var boss_barier = $Barriers/BossFight/CollisionShape2D
@onready var boss_widow_controller = $BossWidowController
@onready var boss_1_scene = $"."

@export var death_scene: PackedScene
@export var cutscene_before_fight :PackedScene
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = cutscene_before_fight.instantiate()
	checkpoint.start_event.connect(start_fight)
	
	instance.end_cutscene.connect(func():
		get_tree().paused = false
		)

func _process(delta):
	if boss_widow_controller == null:
		boss_barier.call_deferred("set_disabled", true)

func start_fight():
	get_tree().paused = true
	get_parent().add_child(instance)
	boss_barier.call_deferred("set_disabled", false)

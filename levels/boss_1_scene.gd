extends Level

@onready var checkpoint = $CheckpointBossFight
@onready var boss_barier = $Barriers/BossFight/CollisionShape2D
@onready var boss_widow_controller = $BossWidowController
@onready var boss_1_scene = $"."

@export var cutscene_before_fight :PackedScene
@export var boss_controller: BossController

var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	boss_controller.boss_death.connect(end_fight)
	
	instance = cutscene_before_fight.instantiate()
	checkpoint.start_event.connect(start_fight)
	
	instance.end_cutscene.connect(func():
		get_tree().paused = false
		)

func _process(delta):
	if boss_widow_controller == null:
		boss_barier.call_deferred("set_disabled", true)

func start_fight():
	checkpoint.set_deferred("monitorable", false)
	if checkpoint.monitorable == true:
		get_tree().paused = true
		get_parent().add_child(instance)
		boss_barier.call_deferred("set_disabled", false)

func end_fight():
	await get_tree().create_timer(2).timeout
	var instance = next_scene.instantiate()
	get_parent().add_child(instance)
	queue_free()

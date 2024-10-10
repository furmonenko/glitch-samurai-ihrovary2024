extends CanvasLayer
class_name Cutscene

@onready var text_timer = $TextTimer
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $SpeakSound
@onready var how_to_skip_container = $HowToSkipContainer
@onready var intro_text = $IntroText

@export var next_scene: PackedScene
@export var max_step :int

var step: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	how_to_skip_container.visible = false
	intro_text.visible_characters = 0
	animation_player.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if step == max_step:
			return
		how_to_skip_container.visible = false
		step += 1
		intro_text.visible_characters = 0
		audio_stream_player.play()
		advance_text(step)
		

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "Finally... I've done it"
		1:
			intro_text.text = "You are my final creation, my last chance to reclaim the city of Victoria"
		2:
			intro_text.text = "I have given you powers even the gods don’t possess"
		3:
			intro_text.text = "The Reds have no idea—you are the glitch in their system, their undoing"
		4:
			intro_text.text = "You are immortal. No wound can kill you"
		5:
			intro_text.text = "You will always return to the Engineer, who will restore you, again and again"
		6:
			intro_text.text = "But remember, your life is mine. I control every step you take, and I can shut you down at any moment"
		7:
			intro_text.text = "Now, go to the Engineer. Recharge and prepare for what’s to come"
			animation_player.play("fade_in")

func _on_text_timer_timeout():
	if intro_text.visible_characters < intro_text.text.length():
		intro_text.visible_characters += 1
	elif animation_player.is_playing():
		how_to_skip_container.visible = false
		how_to_skip_container.process_mode = Node.PROCESS_MODE_DISABLED
		text_timer.stop()
		audio_stream_player.stop()
	else:
		how_to_skip_container.visible = true
		text_timer.stop()
		audio_stream_player.stop()
		
func faded_out():
	advance_text(0)
	audio_stream_player.play()

func faded_in():
	if next_scene:
		var instance = next_scene.instantiate()
		get_parent().add_child(instance)
		queue_free()

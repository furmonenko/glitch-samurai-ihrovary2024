extends Control

@onready var intro_text = $IntroText
@onready var text_timer = $TextTimer
@onready var how_to_skip_container = $HowToSkipContainer
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer


var step: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	how_to_skip_container.visible = false
	intro_text.visible_characters = 0
	animation_player.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		how_to_skip_container.visible = false
		step += 1
		intro_text.visible_characters = 0
		advance_text(step)
		

func advance_text(step: int):
	text_timer.start()
	
	match step:
		0:
			intro_text.text = "Greetings, my old friend."
		1:
			intro_text.text = "I'm glad you made it here so fast."
		2:
			intro_text.text = "Now you need to make your way to the surface."
		3:
			intro_text.text = "Be careful and remember what I teach you."
		4:
			intro_text.text = "[SPACE] - jump, [ARROWS] - move, [F] - attack, [G] - change form"
		5:
			intro_text.text = "Good luck, Samurai."
			animation_player.play("fade_in")
func _on_text_timer_timeout():
	if intro_text.visible_characters < intro_text.text.length():
		intro_text.visible_characters += 1
		audio_stream_player.play()
	else:
		how_to_skip_container.visible = true
		text_timer.stop()
		
func faded_out():
	advance_text(0)

func faded_in():
	pass

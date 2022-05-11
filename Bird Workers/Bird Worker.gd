extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func play_walking():
	anim_player.play("Walking")

func play_talking():
	anim_player.play("Talking")
	
func play_worried():
	anim_player.play("Worried")
	
func play_working_front():
	anim_player.play("Working (Front)")

func play_working_back():
	anim_player.play("Working (Backwards)")

extends Node2D

onready var anim_player = get_node("AnimationPlayer")

func repeat_animation():
	anim_player.seek(0,true)
	anim_player.play("Working Atmosphere 1")

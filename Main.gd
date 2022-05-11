extends Node2D

onready var tools = get_node("YSort/Click Areas/Tools")

var tool_set

func _ready():
	initialize_tools()
	AudioPlayer.play_music(AudioPlayer.cafe_music, -4)

func initialize_tools():
	tool_set = tools.get_children()
	for _tool in tool_set:
		ScoringSystem.tool_set.append(_tool)
	

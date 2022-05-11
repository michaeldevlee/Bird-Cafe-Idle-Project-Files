extends Node2D

onready var label = get_node("Count")
onready var spawn_pos = get_node("Position2D")
onready var current_sprite = get_node("General Sprite")

var stack_count : int = 1
var quality = "AVERAGE_QUALITY"
var revenue = 0 
var sprite = preload("res://Coffee Types/General Coffee Sprite.tscn")


var quality_list = {
	"AVERAGE_QUALITY" : Color(0.8,0.8,0.8),
	"GOOD_QUALITY" : Color(1.2,1.2,1.2),
	"AWESOME_QUALITY" : Color(1.4,1.4,1.4),
	"GOD_TIER" : Color(2,2,2,2)
}

export var sprite_texture : Texture

func _ready():
	label.set_text(name)
	if sprite_texture:
		spawn_pos.position = Vector2(0,-150)
	current_sprite.set_modulate(quality_list[quality])

func stack_coffee():
	stack_count += 1
	
	if stack_count > 1:
		var sprite_instance = sprite.instance()
		var height = sprite_instance.texture.get_height()
		sprite_instance.texture = sprite_texture
		sprite_instance.position += Vector2(0,(stack_count-1) * -120)
		sprite_instance.set_modulate(quality_list[quality])
		spawn_pos.add_child(sprite_instance)
	elif stack_count == 1:
		var sprite_instance = sprite.instance()
		var height = sprite_instance.texture.get_height()
		sprite_instance.position += Vector2(0,stack_count * (-height - 120))
		sprite_instance.set_modulate(quality_list[quality])
		add_child(sprite_instance)
		

	

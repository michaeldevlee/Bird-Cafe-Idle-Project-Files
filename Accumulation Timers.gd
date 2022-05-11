extends Node

onready var customer_timer = get_node("Customer Timer")
onready var customer_timer_text = get_node("Customer Time")

func _process(delta):
	customer_timer_text.set_text(str("%2d" % customer_timer.time_left))

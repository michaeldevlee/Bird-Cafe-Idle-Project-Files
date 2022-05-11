extends ColorRect

var length = rect_size.x
var counter_spaces = 8
var step = length / counter_spaces
var current_step = 0
var space_on_counter = {}

func _ready():
	ScoringSystem.connect("coffee_collection_initiated", self, "collect_made_coffee")
	ScoringSystem.connect("drink_made", self, "place_made_coffee")
	for x in counter_spaces:
		current_step += step
		space_on_counter[Vector2(current_step, 0)] = "EMPTY"

func place_made_coffee(drink : Drink):
	for coordinate in space_on_counter:
		var space = space_on_counter[coordinate]

		if space == "EMPTY":
			space_on_counter[coordinate] = drink.drink_name
			var instance = drink.sprite.instance()
			instance.quality = drink.drink_quality
			instance.revenue = drink.revenue
			instance.position = coordinate
			add_child(instance)
			
			return
		elif space == drink.drink_name:
			for coffee in get_children():
				if coffee.name == drink.drink_name:
					coffee.stack_coffee()
			return

func collect_made_coffee():
	for coffee in get_children():
		space_on_counter[coffee.position] = "EMPTY"
		ScoringSystem.emit_signal("coffee_profit_collection_initiated", coffee)
		coffee.queue_free()
			

func register_signals():
	ScoringSystem.connect("drink_made", self, "place_made_coffee")

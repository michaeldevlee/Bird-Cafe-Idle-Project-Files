extends Control

export var coffee_counter : NodePath
export var money_counter : NodePath
export var stars_path : NodePath

var coffee_count
var money_count
var stars

onready var tween = get_node("Tween")

func _ready():
	coffee_count = get_node(coffee_counter)
	money_count = get_node(money_counter)
	stars = get_node(stars_path)
	register_signals()

func update_coffee_and_money():
	if coffee_count and money_count:
		coffee_count.set_text(str(ScoringSystem.coffee_bean_count))
		money_count.set_text(str(ScoringSystem.money_count))

func update_coffee_and_money_with_juice (amount):
	if coffee_count and money_count:
		coffee_count.set_text(str(ScoringSystem.coffee_bean_count))
		money_count.set_text(str(ScoringSystem.money_count))

func update_stars():
	if stars:
		for star in stars.get_children():
			if star.visible == false:
				tween.interpolate_property(star,"rect_scale", Vector2(1,1), Vector2(2,2), 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
				tween.start()
				yield(tween,"tween_completed")
				tween.interpolate_property(star,"rect_scale", Vector2(2,2), Vector2(1,1), 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
				tween.start()
				star.visible = true
				break
		
		update_final_star()

func update_final_star():
	if stars:
		var visible_count = 0
		
		for star in stars.get_children():
			if star.visible == true:
				visible_count += 1
		
		if visible_count == 5:
			print("you win")

func register_signals():
	ScoringSystem.connect("coffee_profit_collection_initiated", self, "update_coffee_and_money_with_juice")
	ScoringSystem.connect("coffee_bean_collected", self, "update_coffee_and_money_with_juice")
	ScoringSystem.connect("tool_selected", self, "update_coffee_and_money")
	ScoringSystem.connect("coffee_profit_collected", self, "update_coffee_and_money")
	ScoringSystem.connect("star_gained", self, "update_stars")
	ScoringSystem.connect("final_star_check_initiated", self, "update_final_star")

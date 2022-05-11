extends Node

signal coffee_bean_ordered
signal coffee_bean_collected (amount)
signal tool_selected
signal drink_made (drink)
signal drink_stack_initiated (drink)
signal coffee_collection_initiated
signal coffee_profit_collection_initiated(drink)
signal coffee_profit_collected
signal achievement_check_initiated(achievement_name)
signal star_gained
signal final_star_check_initiated

signal update_upgrade_UI(e_req, q_req, tool_name)
signal maxed_out_upgrade(upgrade_name, tool_name)
signal renovation_initiated

signal bean_timer_upgrade(bean_per_second)

var collected_achievements = {
	"20_DRINKS": null,
	"GOOD_QUALITY" : null,
	"GOOD_INTERIOR" : null,
	"AWESOME_QUALITY" : null,
	"ACHIEVED_ALL" : null
}

var collected_coffee = {
	"Drip Coffee" :0,
	"Americano" : 0,
	"Espresso" : 0,
	"Latte" : 0,
	"Mocha" : 0,
	"Frappuccino" : 0,
	"Caramel Macchiato" : 0,
	"Chamomile Tea" : 0,
	"Dalgona Milk Tea" : 0,
	"Total" : 0
}

var quality_multipliers = {
	"AVERAGE_QUALITY" : 1,
	"GOOD_QUALITY" : 1.5,
	"AWESOME_QUALITY" : 2,
	"GOD_TIER" : 3
}

var coffee_bean_count : int = 0
var money_count : int = 0
var tool_set : Array

func _ready():
	connect("coffee_bean_collected", self, "update_coffee_bean_count")
	connect("coffee_profit_collection_initiated", self, "collect_profit")
	connect("achievement_check_initiated", self, "check_star_status")


func collect_profit(drink):
	if drink.is_in_group("Coffee"):
		money_count += drink.revenue * drink.stack_count * quality_multipliers[drink.quality]
		collected_coffee[drink.name] += 1 * drink.stack_count
		collected_coffee["Total"] += 1 * drink.stack_count
		emit_signal("achievement_check_initiated", "20_DRINKS")
		emit_signal("coffee_profit_collected")

func update_coffee_bean_count(amount):
	coffee_bean_count += amount

func check_final_star():
	emit_signal("final_star_check_initiated")
		
func check_star_status(achievement_name : String):

	match achievement_name:
		"20_DRINKS":
			if collected_coffee["Total"] >= 20:
				if collected_achievements["20_DRINKS"] != "COLLECTED":
					collected_achievements["20_DRINKS"] = "COLLECTED"
					emit_signal("star_gained")
					print("made 20 drinks")
					print(collected_achievements)
					
		"QUALITY":
			for _tool in tool_set:
				if collected_achievements["GOOD_QUALITY"] == "COLLECTED":
					break
				if _tool is Coffee_Tool:
					if _tool.current_quality == "GOOD_QUALITY" || _tool.current_quality == "AWESOME_QUALITY" || _tool.current_quality == "GOD_TIER":
						continue
					else:
						print(_tool, " is not good quality yet")
						return
			
			if collected_achievements["GOOD_QUALITY"] != "COLLECTED":
				collected_achievements["GOOD_QUALITY"] = "COLLECTED"
				emit_signal("star_gained")
			
			for _tool in tool_set:
				if collected_achievements["AWESOME_QUALITY"] == "COLLECTED":
					break
				if _tool is Coffee_Tool:
					if _tool.current_quality == "AWESOME_QUALITY" || _tool.current_quality == "GOD_TIER":
						continue
					else:
						print(_tool, " is not awesome quality yet")
						return
			if collected_achievements["AWESOME_QUALITY"] != "COLLECTED":
				collected_achievements["AWESOME_QUALITY"] = "COLLECTED"
				emit_signal("star_gained")
		"GOOD_INTERIOR":
			if collected_achievements["GOOD_INTERIOR"] != "COLLECTED":
				collected_achievements["GOOD_INTERIOR"] = "COLLECTED"
				emit_signal("star_gained")
				

			
		
					

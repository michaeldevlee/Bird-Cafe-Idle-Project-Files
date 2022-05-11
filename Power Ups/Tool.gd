extends Node2D
class_name Coffee_Tool

onready var anim_player = get_node("AnimationPlayer")
onready var timer = get_node("Make Timer")
onready var tween = get_node("Progress Bar/Tween")
onready var progress_bar = get_node("Progress Bar")
onready var debug_label = get_node("Debug")
onready var upgrade_options = get_node("Upgrade Options")
onready var cost = get_node("Sprite/Cost")
onready var sprite = get_node("Sprite")
onready var increase_juice = get_node("Particles2D")

export var drink_resource : Resource

export var quality_requirements = {
	"AVERAGE_QUALITY" : 100,
	"GOOD_QUALITY" : 200,
	"AWESOME_QUALITY" : 300,
}

export var efficiency_requirements = {
	"LEVEL_1": 10,
	"LEVEL_2": 15,
	"LEVEL_3": 20,
	"LEVEL_4": 25,
	"LEVEL_5": 30
}

var efficiency_keys = efficiency_requirements.keys()
var quality_keys = quality_requirements.keys()

var drink_in_process : bool = false
var current_quality = "AVERAGE_QUALITY"
var current_efficiency = "LEVEL_1"
var reached_max_quality : bool = false
var reached_max_efficiency : bool = false
var brew_speed : float = 1.0
var brew_multiplier : float = 1.0

func _ready():
	initialize_stats(efficiency_requirements["LEVEL_1"], quality_requirements["AVERAGE_QUALITY"])
	upgrade_options.connect("upgrade_initiated", self, "check_upgrade")
	debug_label.set_text(name)
	initialize_coffee()
	

func _on_Interact_Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and !drink_in_process:
		if event.button_index == 1 and event.pressed:
			if ScoringSystem.coffee_bean_count >= drink_resource.cost and drink_resource is Drink:
				var time = drink_resource.time_to_make
				
				ScoringSystem.coffee_bean_count -= drink_resource.cost
				ScoringSystem.emit_signal("tool_selected")
				progress_bar.visible = true
				drink_in_process = true
				anim_player.play("Pressed")
				timer.start(time)
				tween.interpolate_property(progress_bar, "value", 0, 100, time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
				tween.playback_speed = brew_speed * brew_multiplier
				tween.start()

func _on_Tween_tween_completed(object, key):
	drink_in_process = false
	progress_bar.visible = false
	AudioPlayer.play_SFX(AudioPlayer.coffee_ready, -3)
	ScoringSystem.emit_signal("drink_made", drink_resource)

func initialize_stats(e_req, q_req):
	upgrade_options.initialize_UI(e_req,q_req)

func initialize_coffee():
	if drink_resource and drink_resource is Drink:
		cost.set_text(str(drink_resource.cost))
		cost.rect_position = Vector2(0, 16)

func _process(delta):
	if get_viewport().get_mouse_position().distance_to(self.global_position) <= 150:
		upgrade_options.visible = true
	else:
		upgrade_options.visible = false
	

func check_upgrade(upgrade_name):
	match upgrade_name:
		"Efficiency":
			
			var current_index = efficiency_keys.find(current_efficiency, 0)
			
			if current_index < efficiency_requirements.size()-1:
				var next_key = efficiency_keys[current_index+1]
				var bean_price = efficiency_requirements[current_efficiency]
		
				if ScoringSystem.coffee_bean_count >= bean_price:
					var e_req = efficiency_requirements[next_key]
					var q_req = quality_requirements[current_quality]
					
					ScoringSystem.coffee_bean_count -= bean_price
					current_efficiency = next_key
					ScoringSystem.emit_signal("update_upgrade_UI", e_req, q_req, name)
					brew_multiplier *= 1.2
					increase_juice.emitting = true
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -3)
				
			else:
				if !reached_max_efficiency:
					var bean_price = efficiency_requirements[current_efficiency]
					if ScoringSystem.coffee_bean_count >= bean_price:
						reached_max_efficiency = true
						brew_multiplier *= 1.2
						increase_juice.emitting = true
						AudioPlayer.play_SFX(AudioPlayer.upgrade, -3)
						ScoringSystem.coffee_bean_count -= bean_price
						ScoringSystem.emit_signal("maxed_out_upgrade", upgrade_name, name)
		"Quality":
			var current_index = quality_keys.find(current_quality, 0)
			
			if current_index < quality_requirements.size()-1:
				var next_key = quality_keys[current_index+1]
				var money_price = quality_requirements[current_quality]
		
				if ScoringSystem.money_count >= money_price:
					var e_req = efficiency_requirements[current_efficiency]
					var q_req = quality_requirements[next_key]
					
					ScoringSystem.money_count -= money_price
					current_quality = next_key
					ScoringSystem.emit_signal("update_upgrade_UI", e_req, q_req, name)
					ScoringSystem.emit_signal("achievement_check_initiated", "QUALITY")
					increase_juice.emitting = true
					drink_resource.drink_quality = current_quality
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -3)
				
			else:
				if !reached_max_quality:
					var money_price = quality_requirements[current_quality]
					if ScoringSystem.money_count >= money_price:
						reached_max_quality = true
						drink_resource.drink_quality = "GOD_TIER"
						ScoringSystem.money_count -= money_price
						ScoringSystem.emit_signal("achievement_check_initiated", "QUALITY")
						increase_juice.emitting = true
						AudioPlayer.play_SFX(AudioPlayer.upgrade, -3)
						ScoringSystem.emit_signal("maxed_out_upgrade", upgrade_name, name)

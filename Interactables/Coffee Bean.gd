extends Node2D

onready var anim_player = get_node("Coffee Bean/AnimationPlayer")
onready var increase_juice = get_node("Particles2D")
onready var bean_text = get_node("Beans Per Click")
onready var beancome_text = get_node("Passive Beancome")

var click_count : int = 0
var beans_per_click = 1
var beans_per_second = 1

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			anim_player.play("Pressed")
			ScoringSystem.emit_signal("coffee_bean_collected", beans_per_click)
			click_count += 1
			AudioPlayer.play_SFX(AudioPlayer.click, -6)
			
			match click_count:
				50:
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beans_per_click += 1
					bean_text.set_text(str(beans_per_click))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
				100:
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beans_per_click += 1 
					bean_text.set_text(str(beans_per_click))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
				125:
					beans_per_second += 1
					ScoringSystem.emit_signal("bean_timer_upgrade", beans_per_second)
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beancome_text.set_text(str(beans_per_second))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
				150:
					beans_per_second += 1
					ScoringSystem.emit_signal("bean_timer_upgrade", beans_per_second)
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beancome_text.set_text(str(beans_per_second))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
				175: 
					beans_per_second += 1
					ScoringSystem.emit_signal("bean_timer_upgrade", beans_per_second)
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beancome_text.set_text(str(beans_per_second))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
				200:
					beans_per_second += 1
					ScoringSystem.emit_signal("bean_timer_upgrade", beans_per_second)
					increase_juice.emitting = true
					anim_player.play("Upgrade")
					beancome_text.set_text(str(beans_per_second))
					AudioPlayer.play_SFX(AudioPlayer.upgrade, -4)
		
		



extends Sprite

onready var anim_player = get_node("AnimationPlayer")
onready var area2D = get_node("Area2D")

export var cost_to_renovate = 2000

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			anim_player.play("Pressed")
			if ScoringSystem.money_count >= cost_to_renovate:
				ScoringSystem.money_count -= cost_to_renovate
				area2D.queue_free()
				ScoringSystem.emit_signal("renovation_initiated")
				ScoringSystem.emit_signal("achievement_check_initiated", "GOOD_INTERIOR")
				
				
			

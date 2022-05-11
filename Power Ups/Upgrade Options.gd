extends Node2D

onready var efficiency_text = get_node("Quantities/Efficiency")
onready var efficiency_cost_text = get_node("Quantities/Efficiency/E_Req")
onready var quality_text = get_node("Quantities/Quality")
onready var quality_cost_text = get_node("Quantities/Quality/Q_Req")

signal upgrade_initiated (type)

func _ready():
	ScoringSystem.connect("update_upgrade_UI", self, "update_UI")
	ScoringSystem.connect("maxed_out_upgrade", self, "remove_req_text")

func initialize_UI(efficiency_req, quality_req):
	efficiency_cost_text.set_text(str(efficiency_req))
	quality_cost_text.set_text(str(quality_req))

func update_UI(efficiency_req, quality_req, tool_name):
	if owner.name != tool_name:
		return
	efficiency_cost_text.set_text(str(efficiency_req))
	quality_cost_text.set_text(str(quality_req))

func remove_req_text(upgrade_name, tool_name):
	if owner.name != tool_name:
		return
	match upgrade_name:
		"Efficiency":
			efficiency_text.visible = false
		"Quality":
			quality_text.visible = false

func _on_Efficiency_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("upgrade_initiated", "Efficiency")

func _on_Quality_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("upgrade_initiated", "Quality")



extends Timer

var beans_per_second : int = 2

func _ready():
	connect("timeout", self, "add_beans")
	ScoringSystem.connect("bean_timer_upgrade", self, "update_bean_per_second")
	
func update_bean_per_second(value):
	beans_per_second = value

func add_beans():
	ScoringSystem.emit_signal("coffee_bean_collected", beans_per_second)

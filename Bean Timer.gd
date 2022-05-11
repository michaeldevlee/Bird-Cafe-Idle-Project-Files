extends Timer

func _ready():
	connect("timeout", self, "test")
	
func test():
	ScoringSystem.emit_signal("coffee_collection_initiated")

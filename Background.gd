extends Sprite


func _ready():
	ScoringSystem.connect("renovation_initiated", self, "test")


func test():
	print("change background")

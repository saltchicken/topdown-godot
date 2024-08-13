extends State

@onready var character_body = self.get_owner()
@onready var sprite = get_owner().get_node("Sprite2D")

func Enter():
	sprite.frame = 1
	pass
	
func Exit():
	print("Drop some wood")
	
func Update(_delta:float):
	pass

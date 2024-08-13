extends State

@onready var character_body = self.get_owner()
@onready var sprite = get_owner().get_node("Sprite2D")
@onready var health_component = get_owner().get_node("HealthComponent")

func Enter():
	sprite.frame = 0
	health_component.full_health()
	pass
	
func Exit():
	pass
	#character_body.despawn.emit()
	
func Update(_delta:float):
	pass

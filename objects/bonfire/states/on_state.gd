extends State

@onready var character_body = self.get_owner()
@onready var animated_sprite = $"../../AnimatedSprite2D"

@export var sfx : AudioStreamPlayer2D

func Enter():
	sfx.play()
	animated_sprite.play("on")
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

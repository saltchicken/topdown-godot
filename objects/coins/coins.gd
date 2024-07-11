class_name Coins
extends Area2D

@onready var value
var Random = RANDOM.new()

func _ready() -> void:
	var choice = Random.weighted_random([75, 20, 5])
	match choice:
		0:
			get_node('Sprite2D').frame_coords = Vector2i(0,0)
			value = 5
		1:
			get_node('Sprite2D').frame_coords = Vector2i(1,0)
			value = 10
		2:
			get_node('Sprite2D').frame_coords = Vector2i(2,0)
			value = 20
		_:
			print('ERROR: not implemented')
	
func collect():
	queue_free()
	

	

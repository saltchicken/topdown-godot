class_name Coins
extends Node2D

@onready var value
var Random = RANDOM.new()

signal collect

func _ready() -> void:
	collect.connect(on_collect)
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
			push_error('ERROR: not implemented')
	
func on_collect():
	Global.get_node("Audio/SFX/CoinCollectSound").play()
	queue_free()
	

	

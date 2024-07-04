extends Node2D

@export var direction_radius = 150
@onready var eight_directions = {
		"up": Vector2(0,1),
		"up_right": Vector2(1,1),
		"right": Vector2(1,0),
		"down_right": Vector2(1,-1),
		"down": Vector2(0,-1),
		"down_left": Vector2(-1,-1),
		"left": Vector2(-1,0),
		"up_left": Vector2(-1,1)
	}
var raycasts = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for direction in eight_directions.keys():
		var r = RayCast2D.new()
		r.target_position = eight_directions[direction].normalized() * direction_radius
		add_child(r)
		raycasts[direction] = r


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for raycast in raycasts.keys():
		var collider = raycasts[raycast].get_collider()
		if collider:
			print(collider)
			pass

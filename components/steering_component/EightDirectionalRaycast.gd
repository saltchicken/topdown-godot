class_name EightDirectionalRaycast extends Node

var direction_radius
var eight_directions

func _init():
	direction_radius = 150
	eight_directions = [
	Vector2(0,1),
	Vector2(1,1),
	Vector2(1,0),
	Vector2(1,-1),
	Vector2(0,-1),
	Vector2(-1,-1),
	Vector2(-1,0),
	Vector2(-1,1)
]	

func create_raycasts(parent_node):
	for direction in eight_directions:
		var raycast = RayCast2D.new()
		raycast.target_position = direction * direction_radius
		parent_node.add_child(raycast)

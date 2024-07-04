class_name EightDirectionalRaycast extends Node

var direction_radius
var eight_directions
var raycasts = {}

func _init():
	direction_radius = 150
	#eight_directions = [
	#Vector2(0,1),
	#Vector2(1,1),
	#Vector2(1,0),
	#Vector2(1,-1),
	#Vector2(0,-1),
	#Vector2(-1,-1),
	#Vector2(-1,0),
	#Vector2(-1,1)
#]	
	eight_directions = {
		"up": Vector2(0,1),
		"up_right": Vector2(1,1),
		"right": Vector2(1,0),
		"down_right": Vector2(1,-1),
		"down": Vector2(0,-1),
		"down_left": Vector2(-1,-1),
		"left": Vector2(-1,0),
		"up_left": Vector2(-1,1)
	}

#func create_raycasts(parent_node):
	#for direction in eight_directions:
		#var raycast = RayCast2D.new()
		#raycast.target_position = direction * direction_radius
		#parent_node.add_child(raycast)
		
func create_raycasts(parent_node):
	for direction in eight_directions.keys():
		var raycast = RayCast2D.new()
		raycast.target_position = eight_directions[direction].normalized() * direction_radius
		parent_node.add_child(raycast)
		raycasts[direction] = raycast

func process():
	for raycast in raycasts.keys():
		var ray  = raycasts[raycast]
		var collider = ray.get_collider()
		if collider:
			#print(collider)
			pass

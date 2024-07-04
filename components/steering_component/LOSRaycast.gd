class_name LOSRaycast extends Node

@onready var distance_to_player_last_known_pos
@onready var direction_to_player_last_known_pos

@onready var raycast
@onready var perpendicular_line = get_node('RayCast2D/Line2D')
@onready var player_los = false
@onready var previous_los = false
@onready var last_known_pos = null

@onready var perpendicular_line_magnitude = 50

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	pass
	
func create_raycast(parent_node):
	var r = RayCast2D.new()
	parent_node.add_child(r)
	raycast = r
	
func process(parent_node, player) -> void:
	if !player:
		player_los = false
	lost_los_handler(player)
	raycast_handler(parent_node, player)
	
func raycast_handler(parent_node, player):
	if player:
		raycast.target_position = player.global_position - parent_node.global_position
		var collider = raycast.get_collider()
		if collider is Player:
			player_los = true
			last_known_pos = collider.global_position
		else:
			player_los = false

func lost_los_handler(player):
	if (!player_los or !player) and previous_los:
		print("Lost line of sight")
		#var lost_loc_pos = los_raycast.get_collision_point() # pos that blocked AI's LOS
	previous_los = player_los
	
func set_distance_and_direction_to_player_last_known_position(parent_node):
	distance_to_player_last_known_pos = parent_node.global_position.distance_to(last_known_pos)
	direction_to_player_last_known_pos = parent_node.global_position.direction_to(last_known_pos)

func calculate_end_point(slope, magnitude):
	var x = magnitude / sqrt(1 + slope ** 2)
	var y = slope * x
	return Vector2(x, y)
	
func set_perpendicular_line():
	var slope = raycast.target_position.y / raycast.target_position.x
	var perpendicular_slope = -1 / slope
	var end_point = calculate_end_point(perpendicular_slope, perpendicular_line_magnitude)
	perpendicular_line.set_point_position(0, -end_point)
	perpendicular_line.set_point_position(1, end_point)

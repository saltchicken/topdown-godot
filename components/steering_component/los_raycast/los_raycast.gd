extends Node2D

@export var steering_component : SteeringComponent
@export var perpendicular_line_magnitude = 50

@onready var distance_to_player_last_known_pos
@onready var direction_to_player_last_known_pos

@onready var raycast = get_node("RayCast2D")
@onready var perpendicular_line = get_node("PerpLine")
@onready var player_los = false
#@onready var previous_los = false
@onready var last_known_pos = null


func _physics_process(delta: float) -> void: # TODO: Should this be called so often?
	if !steering_component.player:
		player_los = false
	#lost_los_handler()
	raycast_handler()
	set_distance_and_direction_to_player_last_known_position()
	if last_known_pos:
		Debug.draw_point(last_known_pos)
	#set_perpendicular_line()

func raycast_handler():
	if steering_component.player:
		raycast.target_position = steering_component.player.global_position - global_position
		var collider = raycast.get_collider()
		if collider is Player:
			player_los = true
			last_known_pos = collider.global_position
		else:
			player_los = false

#func lost_los_handler():
	#if (!player_los or !steering_component.player) and previous_los:
		#print("Lost line of sight")
		##Debug.draw_point(raycast.get_collision_point())
		##var lost_loc_pos = los_raycast.get_collision_point() # pos that blocked AI's LOS
	#previous_los = player_los
	
func set_distance_and_direction_to_player_last_known_position():
	if last_known_pos:
		distance_to_player_last_known_pos = global_position.distance_to(last_known_pos)
		direction_to_player_last_known_pos = global_position.direction_to(last_known_pos)

func calculate_end_point(slope, magnitude):
	var x = magnitude / sqrt(1 + slope ** 2)
	var y = slope * x
	return Vector2(x, y)
	
func set_perpendicular_line():
	if steering_component.player:
		var slope = raycast.target_position.y / raycast.target_position.x
		var perpendicular_slope = -1 / slope
		var end_point = calculate_end_point(perpendicular_slope, perpendicular_line_magnitude)
		perpendicular_line.set_point_position(0, -end_point)
		perpendicular_line.set_point_position(1, end_point)

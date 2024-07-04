class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player
@onready var distance_to_player_last_known_pos
@onready var direction_to_player_last_known_pos

@onready var los_raycast = get_node('RayCast2D')
@onready var los_raycast_perpendicular_line = get_node('RayCast2D/Line2D')
@onready var player_los = false
@onready var previous_los = false
@onready var last_known_pos = null

@onready var DEBUG_points = []

var eight_directional_raycast = EightDirectionalRaycast.new()




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eight_directional_raycast.create_raycasts(self)
	
func _draw():
	for point in DEBUG_points:
		draw_circle(point - global_position, 5, Color.WHITE)
	
func _physics_process(_delta: float) -> void:
	queue_redraw()
	check_for_player()
	lost_los_handler()
	if player:
		set_distance_and_direction_to_player()
		los_raycast_handler()
		set_perpendicular_line(los_raycast.target_position, 50)
		
func set_perpendicular_line(target_position, magnitude):
	var slope = target_position.y / target_position.x
	var perpendicular_slope = -1 / slope
	var end_point = calculate_end_point(perpendicular_slope, magnitude)
	los_raycast_perpendicular_line.set_point_position(0, -end_point)
	los_raycast_perpendicular_line.set_point_position(1, end_point)

func calculate_end_point(slope, magnitude):
	var x = magnitude / sqrt(1 + slope ** 2)
	var y = slope * x
	return Vector2(x, y)
	
func lost_los_handler():
	if (!player_los or !player) and previous_los:
		var lost_loc_pos = los_raycast.get_collision_point() # pos that blocked AI's LOS
		DEBUG_points.append(last_known_pos)
		#var marker = Marker2D.new()
		#marker.position = los_raycast.get_collision_point()
		#add_child(marker)
	previous_los = player_los

func los_raycast_handler():
	los_raycast.target_position = player.global_position - global_position
	var collider = los_raycast.get_collider()
	if collider is Player:
		player_los = true
		last_known_pos = collider.global_position
	else:
		player_los = false
		
func check_for_player():
	player = null
	for body in self.get_overlapping_bodies():
		if body is Player:
			player = body
	if !player:
		player_los = false

func set_distance_and_direction_to_player():
	distance_to_player = self.global_position.distance_to(player.global_position)
	direction_to_player = self.global_position.direction_to(player.global_position)
	idle_direction = direction_to_player
	
func set_distance_and_direction_to_player_last_known_position():
	distance_to_player_last_known_pos = self.global_position.distance_to(last_known_pos)
	direction_to_player_last_known_pos = self.global_position.direction_to(last_known_pos)
	idle_direction = direction_to_player_last_known_pos
	
		
func parse_steering_direction(current_state):
	match current_state.name:
		"idle":
			if player:
				current_state.state_transition.emit(current_state, 'chase')
		"chase":
			if !player:
				current_state.state_transition.emit(current_state, 'idle')
		_:
				print('parse_steering_direction state not handled yet')

class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player

@onready var raycast = get_node('RayCast2D')
@onready var raycast_perpendicular_line = get_node('RayCast2D/Line2D')
@onready var player_los = false
@onready var previous_los = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var rot = PI/2
	#var t = Transform2D()
	#t.x.x = cos(rot)
	#t.y.y = cos(rot)
	#t.x.y = sin(rot)
	#t.y.x = -sin(rot)
	#r_90_counterclockwise = t
	
func _physics_process(_delta: float) -> void:
	check_for_player()
	if player:
		set_distance_and_direction_to_player()
		raycast_handler()
		set_perpendicular_line(raycast.target_position, 50)
		lost_los_handler()
		
func set_perpendicular_line(target_position, magnitude):
	var slope = target_position.y / target_position.x
	var perpendicular_slope = -1 / slope
	var end_point = calculate_end_point(perpendicular_slope, magnitude)
	raycast_perpendicular_line.set_point_position(0, -end_point)
	raycast_perpendicular_line.set_point_position(1, end_point)

func calculate_end_point(slope, magnitude):
	var x = magnitude / sqrt(1 + slope ** 2)
	var y = slope * x
	return Vector2(x, y)
	
func lost_los_handler():
	if !player_los and previous_los:
		print(raycast.get_collider())
		print(raycast.get_collision_point())
		#var marker = Marker2D.new()
		#marker.position = raycast.get_collision_point()
		#add_child(marker)
	previous_los = player_los

func raycast_handler():
	raycast.target_position = player.global_position - global_position
	if raycast.get_collider() is Player:
		player_los = true
	else:
		player_los = false
		
func check_for_player():
	player = null
	for body in self.get_overlapping_bodies():
		if body is Player:
			player = body

func set_distance_and_direction_to_player():
	distance_to_player = self.global_position.distance_to(player.global_position)
	direction_to_player = self.global_position.direction_to(player.global_position)
	idle_direction = direction_to_player
	
		
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

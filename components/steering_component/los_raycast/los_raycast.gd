extends Behavior

@export var color : Color
#@export var perpendicular_line_magnitude = 50

var player = null
@onready var area = get_node("Area2D")
@onready var distance_to_player_last_known_pos
@onready var direction_to_player_last_known_pos

@onready var raycast = get_node("RayCast2D")
#@onready var perpendicular_line = get_node("PerpLine")
@onready var player_los = false
#@onready var previous_los = false
@onready var last_known_pos = null
@onready var arrival_radius = 20

signal player_los_exists

func lost_los():
	player_los_exists.emit(false)
	
func found_los():
	player_los_exists.emit(true)


	
#var lines = []
	
#func _ready():
	#for direction in range(directions.size()):
		#var l = Line2D.new()
		#l.width = 1
		#l.default_color = color
		#l.add_point(Vector2.ZERO)
		#l.add_point(directions[direction].normalized() * 50)
		#add_child(l)
		#
		#lines.append(l)


func update():
	player = check_for_player()
	if !player:
		player_los = false
	#lost_los_handler()
	raycast_handler()
	set_distance_and_direction_to_player_last_known_position()
	calculate_directional_weights()
	check_if_at_last_known_pos()
	if last_known_pos != null:
		Debug.draw_point(last_known_pos)
	#set_perpendicular_line()
	output_velocity()
	
func check_for_player():
	for body in area.get_overlapping_bodies():
		if body is Player:
			return body
	#lost_los()
	return null

func check_if_at_last_known_pos():
	if last_known_pos:
		var distance_to_last_known_pos = global_position.distance_to(last_known_pos)
		if distance_to_last_known_pos <= arrival_radius:
			last_known_pos = null
			print('reached last_known_pos. Stop enemy from wandering off at same velocity')
			

func output_velocity():
	velocity = direction_to_player_last_known_pos
	
func raycast_handler():
	if player:
		raycast.target_position = player.global_position - global_position
		var collider = raycast.get_collider()
		if collider is Player:
			if player_los == false:
				found_los()
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
	if last_known_pos != null:
		distance_to_player_last_known_pos = global_position.distance_to(last_known_pos)
		direction_to_player_last_known_pos = global_position.direction_to(last_known_pos)
	else:
		distance_to_player_last_known_pos = Vector2.ZERO
		direction_to_player_last_known_pos = Vector2.ZERO

#func calculate_end_point(slope, magnitude):
	#var x = magnitude / sqrt(1 + slope ** 2)
	#var y = slope * x
	#return Vector2(x, y)
	#
#func set_perpendicular_line():
	#if steering_component.player:
		#var slope = raycast.target_position.y / raycast.target_position.x
		#var perpendicular_slope = -1 / slope
		#var end_point = calculate_end_point(perpendicular_slope, perpendicular_line_magnitude)
		#perpendicular_line.set_point_position(0, -end_point)
		#perpendicular_line.set_point_position(1, end_point)
		
func calculate_directional_weights():
	var target = last_known_pos
	if target != null:
		var target_direction = self.global_position.direction_to(target)
		if target_direction:
			for direction in range(directions.size()):
				var dot_product = target_direction.dot(directions[direction].normalized())
				weights[direction] = dot_product
				#if dot_product > 0:
					#lines[direction].set_point_position(1, directions[direction].normalized() * dot_product * 100) # TODO: Make variable for weighted_line length
				#else:
					#lines[direction].set_point_position(1, Vector2.ZERO)
	#else:
		#for direction in range(directions.size()):
			#lines[direction].set_point_position(1, Vector2.ZERO)

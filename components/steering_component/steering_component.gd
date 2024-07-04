class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player

#@onready var DEBUG_points = []

var eight_directional_raycast = EightDirectionalRaycast.new()
var los_raycast = LOSRaycast.new()

func _ready() -> void:
	eight_directional_raycast.create_raycasts(self)
	los_raycast.create_raycast(self)
	#for raycast in eight_directional_raycast.raycasts.keys():
		#print(eight_directional_raycast.raycasts[raycast])
		
	
#func _draw():
	#for point in DEBUG_points:
		#draw_circle(point - global_position, 5, Color.WHITE)
	
func _physics_process(_delta: float) -> void:
	#queue_redraw()
	player = check_for_player()
	eight_directional_raycast.process()
	los_raycast.process(self, player)
	if player:
		set_distance_and_direction_to_player()
		#set_perpendicular_line(los_raycast.target_position, 50)
		
		
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null

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

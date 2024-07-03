class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player

@onready var raycast = get_node('RayCast2D')
@onready var player_los = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _physics_process(_delta: float) -> void:
	check_for_player()
	if player:
		set_distance_and_direction_to_player()
		raycast_handler()
	print(player_los)

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

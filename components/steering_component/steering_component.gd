class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player
	
func _physics_process(_delta: float) -> void:
	player = check_for_player()
	set_distance_and_direction_to_player(player)
		
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null

func set_distance_and_direction_to_player(player):
	if player:
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

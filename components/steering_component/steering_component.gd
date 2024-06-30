class_name SteeringComponent extends Area2D

@export var chase_speed := 10.0

@onready var direction = Vector2(1,0) # TODO: This needs to be set to whatever wander is supposed to do
@onready var player
@onready var distance_to_player
@onready var direction_to_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

		
func parse_steering_direction(current_state):
	player = null
	for body in self.get_overlapping_bodies():
		if body is Player:
			player = body
			match current_state.name:
				'idle':
					print('chasing')
					current_state.state_transition.emit(current_state, 'chase')
				'chase':
					pass
				_:
					print('parse_steering_direction state not handled yet')
	if player:
		distance_to_player = self.global_position.distance_to(player.global_position)
		direction_to_player = self.global_position.direction_to(player.global_position)
	else:
		match current_state.name:
			'idle':
				pass
			'chase':
				current_state.state_transition.emit(current_state, 'idle')
			_:
				print('parse_steering_direction state not handled yet')

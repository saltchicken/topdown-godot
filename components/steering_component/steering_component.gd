class_name SteeringComponent extends Area2D

@export var chase_speed := 30.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player

var behaviors = []
var final_weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var final_velocity = Vector2.ZERO

@onready var debug_desired_direction = get_node("Line2D")

func _ready():
	var behavior_nodes = get_children()
	if behavior_nodes.size() > 0:
		for b in behavior_nodes:
			if b is Behavior:
				behaviors.append(b)
		
	
func _physics_process(_delta: float) -> void:
	player = check_for_player()
	set_distance_and_direction_to_player(player)
	check_for_weights()
		
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null
	
func check_for_weights():
	final_weights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	var velocities = []
	for behavior in behaviors:
		for i in range(behavior.weights.size()):
			final_weights[i] += behavior.weights[i]
	
	for i in range(behaviors[0].directions.size()):
		velocities.append(final_weights[i] * behaviors[0].directions[i].normalized())
		
	final_velocity = sum(velocities).normalized()
	debug_desired_direction.set_point_position(1, final_velocity * 50)
	
func sum(arr:Array):
	var result = Vector2.ZERO
	for i in arr:
		result+=i
	return result

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

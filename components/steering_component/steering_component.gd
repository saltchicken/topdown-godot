class_name SteeringComponent extends Area2D

@export var chase_speed := 50.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var behaviors = get_behaviors()
var direction = null
	
func _physics_process(_delta: float):
	player = check_for_player()
	#set_distance_and_direction_to_player(player)
	for behavior in behaviors:
		behavior.update()
	check_for_weights()

func get_behaviors():
	var behavior_nodes = []
	for node in get_children():
		if node is Behavior:
			behavior_nodes.append(node)
			node.override_behaviors.connect(on_override_behavior)
	return behavior_nodes
		
func on_override_behavior():
	print('Behavior override')
	
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null
	
func check_for_weights():
	direction = Vector2.ZERO
	for behavior in behaviors:
		if behavior.direction:
			direction += behavior.direction
	direction = direction.normalized()
	

		
func parse_steering_direction(current_state):
	match current_state.name:
		"idle":
			if player:
				current_state.state_transition.emit(current_state, 'chase')
		"chase":
			if !player and !direction:
				current_state.state_transition.emit(current_state, 'idle')
		_:
				print('parse_steering_direction state not handled yet')

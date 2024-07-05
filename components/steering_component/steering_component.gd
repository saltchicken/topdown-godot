class_name SteeringComponent extends Area2D

@export var chase_speed := 60.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var player
@onready var distance_to_player
@onready var direction_to_player

@onready var behaviors = get_behaviors()
var final_velocity = Vector2.ZERO

@onready var debug_desired_direction = get_node("Line2D")

#func _ready():
	#get_node('Timer').timeout.connect(update)
	
func _physics_process(_delta: float):
	player = check_for_player()
	set_distance_and_direction_to_player(player)
	for behavior in behaviors:
		behavior.update()
	check_for_weights()

func get_behaviors():
	var behavior_nodes = []
	for node in get_children():
		if node is Behavior:
			behavior_nodes.append(node)
	return behavior_nodes
		
func check_for_player():
	for body in self.get_overlapping_bodies():
		if body is Player:
			return body
	return null
	
func check_for_weights():
	final_velocity = Vector2.ZERO
	for behavior in behaviors:
		if behavior.velocity:
			final_velocity += behavior.velocity
	final_velocity = final_velocity.normalized()
	
	

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

class_name SteeringComponent extends Node2D

@export var chase_speed := 50.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var behaviors = get_behaviors()
var direction = Vector2.ZERO
var previous_direction = direction

func init():
	for behavior in behaviors:
		if behavior.has_method('init'):
			behavior.init()

func update():
	for behavior in behaviors:
		behavior.update()
	check_for_weights()

func get_behaviors():
	var behavior_nodes = []
	for node in get_children():
		if node is Behavior:
			behavior_nodes.append(node)
	return behavior_nodes

func check_for_weights():
	previous_direction = direction
	for behavior in behaviors:
		if behavior.direction != null and !is_nan(behavior.direction.x) and !is_nan(behavior.direction.y): # TODO: Handle this in the behavior
			#direction += behavior.direction
			direction = direction.lerp(behavior.direction, behavior.steer_power)
	direction = direction.normalized()

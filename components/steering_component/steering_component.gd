class_name SteeringComponent extends Node2D

@export var chase_speed := 50.0

@onready var idle_direction = Vector2(0.0, -1.0)
@onready var behaviors = get_behaviors()

var direction = null
	
func _physics_process(_delta: float):
	for behavior in behaviors:
		behavior.update()
	check_for_weights()

func get_behaviors():
	var behavior_nodes = []
	for node in get_children():
		if node is Behavior:
			behavior_nodes.append(node)
			if hasSignal(node, 'player_los_exists'):
				node.player_los_exists.connect(handle_los)
	return behavior_nodes
	
func handle_los(boolean):
	if boolean:
		print('Gained LOS')
	else:
		print('Lost LOS')
	
func check_for_weights():
	direction = Vector2.ZERO
	for behavior in behaviors:
		if behavior.velocity:
			direction += behavior.velocity
	direction = direction.normalized()
	
func hasSignal(node : Node, signalName : String) -> bool:
	var signalList = node.get_signal_list()
	for signalDictionary in signalList:
		if signalDictionary.name == signalName:
			return true
	return false
	

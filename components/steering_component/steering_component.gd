class_name SteeringComponent extends Node2D

@export var chase_speed := 50.0

@onready var idle_direction = Vector2(0.0, -1.0)
#@onready var player
@onready var behaviors = get_behaviors()
var direction = Vector2.ZERO
var previous_direction = direction


#@onready var debug_area = get_node("CollisionShape2D")
#var behavior_override = false
	
func update():
	#player = check_for_player()
	#set_distance_and_direction_to_player(player)
	for behavior in behaviors:
		behavior.update()
	check_for_weights()
	#Debug.circle('Area', self, Vector2(debug_area.shape.radius, 0))

func get_behaviors():
	var behavior_nodes = []
	for node in get_children():
		if node is Behavior:
			behavior_nodes.append(node)
			#node.override_behaviors.connect(on_override_behavior)
	return behavior_nodes
		
#func on_override_behavior(switch):
	#print('Behavior override')
	#behavior_override = switch
	#var state_machine = owner.get_node('StateMachine') # TODO: Should not be calling state_machine this way.
	#state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')

	
func check_for_weights():
	#direction = Vector2.ZERO
	#if behavior_override:
		#return
	previous_direction = direction
	for behavior in behaviors:
		if behavior.direction != null and !is_nan(behavior.direction.x) and !is_nan(behavior.direction.y): # TODO: Handle this in the behavior
			#direction += behavior.direction
			direction = direction.lerp(behavior.direction, behavior.steer_power)
			#prints(behavior, direction)
	direction = direction.normalized()
	#print(direction)

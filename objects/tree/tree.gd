class_name Tree_ extends StaticBody2D

@export var initial_state : State

@onready var state_machine = get_node("StateMachine")

@export var experience = 0

@onready var phases = get_node_or_null("PhaseComponent")

signal death
signal despawn
signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death.connect(on_death)
	despawn.connect(on_despawn)
	hit.connect(on_hit)

func on_death():
	print("tree on death called")
	if phases:
		var index = phases.phases.find(state_machine.current_state)
		if index < phases.phases.size() - 1:
			state_machine.current_state.state_transition.emit(state_machine.current_state, phases.phases[index+1].name)
		else:
			despawn.emit()
	
	# TODO: The following block should never be called. Here to possibly put in a parent class. Maybe make phases a requirement.
	else:
		print_debug("Bypassing phases in tree")
		if state_machine.current_state.name != 'stump':
					state_machine.current_state.state_transition.emit(state_machine.current_state, 'stump')
		else:
			despawn.emit()
	
	
func on_despawn():
	print("despawning tree")
	get_node("Drop").drop_items()
	queue_free()

func on_hit(attack : Attack):
	print("Tree hit by ", attack.attacker)
	
func save():
	var save_dict = {
		"name" : name,
		"test" : "test_saved"
	}
	return save_dict

class_name Tree_ extends StaticBody2D

@export var initial_state : State

@onready var state_machine = get_node("StateMachine")

@export var experience = 0

signal death
signal despawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death.connect(on_death)
	despawn.connect(on_despawn)

func on_death():
	print("tree on death called")
	if state_machine.current_state.name != 'stump':
				state_machine.current_state.state_transition.emit(state_machine.current_state, 'stump')
	else:
		despawn.emit()
	
	
func on_despawn():
	print("despawning tree")
	get_node("Drop").drop_items()
	queue_free()


func save():
	var save_dict = {
		"name" : name,
		"test" : "test_saved"
	}
	return save_dict

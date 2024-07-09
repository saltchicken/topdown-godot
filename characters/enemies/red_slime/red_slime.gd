class_name RedSlime extends Enemy

signal idle
signal moving

@onready var state_machine = get_node("StateMachine")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle.connect(on_idle)
	moving.connect(on_moving)
	pass # Replace with function body.


func on_idle():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')
	
func on_moving():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'chase')

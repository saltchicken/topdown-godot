class_name RedSlime extends Enemy

signal idle
signal moving
signal hit
signal death


@onready var state_machine = get_node("StateMachine")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle.connect(on_idle)
	moving.connect(on_moving)
	hit.connect(on_hit)
	death.connect(on_death)
	pass # Replace with function body.


func on_idle():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')
	
func on_moving():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'chase')
	
func on_hit(attack : Attack):
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', attack)
	
func on_death():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')

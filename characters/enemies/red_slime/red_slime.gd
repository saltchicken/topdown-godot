class_name RedSlime extends Enemy

@export var i_frames: float = 0.0

signal idle
signal moving
signal hit
signal death
signal deflect
signal despawn


@onready var state_machine = get_node("StateMachine")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle.connect(on_idle)
	moving.connect(on_moving)
	hit.connect(on_hit)
	death.connect(on_death)
	deflect.connect(on_deflect)
	despawn.connect(on_despawn)
	pass # Replace with function body.


func on_idle():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')
	
func on_moving():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'chase')
	
func on_hit(attack : Attack):
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', attack)
	
func on_death():
	get_node("Drop").drop_items()
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
	
func on_deflect(direction):
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'deflect', direction)
	
func on_despawn():
	#get_node("Drop").drop_items()
	queue_free()
	

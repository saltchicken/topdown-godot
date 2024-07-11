class_name RedSlime extends Enemy

@export var i_frames: float = 0.0

@onready var despawn_drop = preload('res://objects/coins/coins.tscn')

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
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
	
func on_deflect(direction):
	print('deflect')
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'deflect', direction)
	
func on_despawn():
	var drop = despawn_drop.instantiate()
	drop.global_position = global_position
	get_tree().current_scene.get_node("LevelHolder").get_children()[0].add_child(drop) # TODO: Need a better way of selecting the current level
	queue_free()
	

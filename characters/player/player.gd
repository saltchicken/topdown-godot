class_name Player extends CharacterBody2D

@export var initial_state: State

@export var run_speed: float = 300

@onready var state_machine = get_node("StateMachine")

@onready var collision

signal idle
signal moving
signal hit
signal death

func _ready() -> void:
	idle.connect(on_idle)
	moving.connect(on_moving)
	hit.connect(on_hit)
	death.connect(on_death)
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity * delta) # TODO: Maybe move this to the state_machine's update


func on_idle():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')
	
func on_moving():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'chase')
	
func on_hit(attack : Attack):
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', attack)
	
func on_death():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')


	

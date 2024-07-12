class_name Player extends CharacterBody2D

@export var initial_state: State

@export var run_speed: float = 300

@onready var state_machine = get_node("StateMachine")

@onready var collision

@export var i_frames: float = 0.5

signal idle
signal moving
signal dash
signal hit
signal death
signal attack_1
signal attack_2
signal use

func _ready() -> void:
	idle.connect(on_idle)
	moving.connect(on_moving)
	dash.connect(on_dash)
	hit.connect(on_hit)
	death.connect(on_death)
	attack_1.connect(on_attack_1)
	attack_2.connect(on_attack_2)
	use.connect(on_use)
	
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity * delta) # TODO: Maybe move this to the state_machine's update
	
func disable():
	var input_components = find_children('InputComponent')
	for input_component in input_components:
		input_component.disable()
		
func enable():
	var input_components = find_children('InputComponent')
	for input_component in input_components:
		input_component.enable()

func on_idle():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'idle')
	
func on_moving():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'run')
	
func on_dash():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'dash')
	
func on_hit(attack_object : Attack):
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', attack_object)
	
func on_death():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
	
func on_attack_1():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'sword_attack_1')
	
func on_attack_2():
	state_machine.current_state.state_transition.emit(state_machine.current_state, 'sword_attack_2')
	
func on_use():
	var interact_component = get_node_or_null("InteractComponent")
	if interact_component: # TODO: Interact with the closest one
		interact_component.interact()
		


	

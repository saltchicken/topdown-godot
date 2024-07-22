class_name Player extends CharacterBody2D

@export var initial_state: State

@export var run_speed: float = 300
@onready var state_machine = get_node("StateMachine")
@onready var pause_menu_node = get_node("PauseMenu")
@onready var profile = get_node("ProfileComponent")

@onready var collision
@export var i_frames: float = 0.5

signal idle
signal moving
signal dash
signal hit
signal death
signal action
signal interact
signal collect
signal pause_menu

func _ready() -> void:
	add_to_group('PlayerProfilePersist')
	add_to_group('light')
	idle.connect(on_idle)
	moving.connect(on_moving)
	dash.connect(on_dash)
	hit.connect(on_hit)
	death.connect(on_death)
	action.connect(on_action)
	interact.connect(on_interact)
	collect.connect(on_collect)
	pause_menu.connect(on_pause_menu)
	
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity * delta) # TODO: Maybe move this to the state_machine's update
	
func disable():
	#print_debug("Player Disabled")
	var input_components = find_children('InputComponent')
	for input_component in input_components:
		input_component.disable()
		
func enable():
	#print_debug("Player Enabled")
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
	
func on_action():
	if state_machine.current_state.name != 'sword_attack_1':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'sword_attack_1')
	elif state_machine.current_state.name == 'sword_attack_1':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'sword_attack_2')
	
func on_interact():
	var interact_component = get_node_or_null("InteractComponent")
	if interact_component: # TODO: Interact with the closest one
		interact_component.interact()
		
func on_collect(collectable):
	if collectable is Coins:
		profile.coins += collectable.value
		
func on_pause_menu():
	if pause_menu_node.visible:
		pause_menu_node.close_pause_menu()
	else:
		pause_menu_node.open_pause_menu()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_path" : get_path(),
		"name" : name,
		"current_level" : get_node('/root/Gameplay').current_level.get_scene_file_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict

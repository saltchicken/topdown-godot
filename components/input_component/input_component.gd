extends Node
class_name InputComponent

@onready var input_disabled = false

@onready var direction: Vector2
@onready var joystick_direction: Vector2
@onready var previous_direction: Vector2
#@onready var direction_release_smoothing: Array[Vector2] = []
@onready var use: bool
@onready var sneak: bool
@onready var dash: bool
@onready var attack: bool
@onready var cast: bool

#func _ready():
	#for i in range(10):
		#direction_release_smoothing.append(Vector2.ZERO)

func _physics_process(_delta: float) -> void:
	if !input_disabled:
		direction = Input.get_vector("left", "right", "up", "down")
		joystick_direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
		if joystick_direction:
			direction = joystick_direction
		if direction:
			previous_direction = direction
			#direction_release_smoothing.append(direction)
			#direction_release_smoothing.remove_at(0)
			#if direction_release_smoothing.all(func(e): return e == direction_release_smoothing.front()): # True if all elements are equal
				#previous_direction = direction
		use = Input.is_action_just_pressed('use')
		sneak = Input.is_action_pressed('sneak')
		dash = Input.is_action_just_pressed('dash')
		attack = Input.is_action_just_pressed('attack')
		cast = Input.is_action_just_pressed('cast')
		#parse_input_actions()
		#parse_input_direction()
	
#func parse_input_actions() -> String:
	#if use:
		#return 'use'
	#if sneak:
		#return 'sneak'
	#if dash:
		#return 'dash'
	#if attack:
		#return 'attack'
	#if cast:
		#return 'cast'
	#return ''
	
func parse_input_action(current_state) -> void:
	if attack:
		current_state.state_transition.emit(current_state, 'sword_attack')
		

func parse_input_direction(current_state) -> void:
	match current_state.name:
		'idle':
			if direction:
				current_state.state_transition.emit(current_state, 'run')
		'run':
			if !direction:
				current_state.state_transition.emit(current_state, 'idle')
		_:
			if direction:
				current_state.state_transition.emit(current_state, 'run')
			else:
				current_state.state_transition.emit(current_state, 'idle')
	current_state.state_movement()

func disable():
	input_disabled = true
	
func enable():
	input_disabled = false

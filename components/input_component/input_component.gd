class_name InputComponent extends Mover

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

@onready var modules = get_modules()

#func _ready():
	#for i in range(10):
		#direction_release_smoothing.append(Vector2.ZERO)

func update() -> void:
	for module in modules:
		module.update()
	get_input()
	
func get_modules():
	var module_nodes = []
	for node in get_children():
		if node is InputModule:
			module_nodes.append(node)
	return module_nodes
	
func get_input():
	for module in modules:
		if module.direction != null and !is_nan(module.direction.x) and !is_nan(module.direction.y): # TODO: Handle this in the behavior
			#direction += behavior.direction
			direction = direction.lerp(module.direction, module.steer_power)
		if module.attack != null:
			attack = module.attack
	direction = direction.normalized()

	
#func parse_input_action(current_state) -> void:
	#if attack:
		#current_state.state_transition.emit(current_state, 'sword_attack')
		#
#
#func parse_input_direction(current_state) -> void:
	#match current_state.name:
		#'idle':
			#if direction:
				#current_state.state_transition.emit(current_state, 'run')
		#'run':
			#if !direction:
				#current_state.state_transition.emit(current_state, 'idle')
		#_:
			#if direction:
				#current_state.state_transition.emit(current_state, 'run')
			#else:
				#current_state.state_transition.emit(current_state, 'idle')
	#current_state.state_movement()

func disable():
	input_disabled = true
	
func enable():
	input_disabled = false

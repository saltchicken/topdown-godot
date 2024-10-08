extends Node
class_name InputComponent

@onready var input_disabled = false

@onready var direction: Vector2
@onready var joystick_direction: Vector2
@onready var previous_direction: Vector2 = Vector2(0.0, 1.0) # TODO: This shouldn't be needed. This just needs to be set to the default idle position so that spell has direction when referring to the caster.
#@onready var direction_release_smoothing: Array[Vector2] = []
@onready var interact: bool
@onready var sneak: bool
@onready var dash: bool
@onready var action: bool
@onready var cast: bool
@onready var use: bool

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
		interact = Input.is_action_just_pressed('interact')
		sneak = Input.is_action_pressed('sneak')
		dash = Input.is_action_just_pressed('dash')
		action = Input.is_action_just_pressed('action')
		cast = Input.is_action_just_pressed('cast')
		use = Input.is_action_just_pressed('use')
	
func parse_input_action() -> void:
	if action:
		owner.action.emit()
	if use:
		owner.use.emit()
	if dash:
		owner.dash.emit()
	if interact:
		owner.interact.emit()
	if cast:
		owner.cast.emit()

func disable():
	input_disabled = true
	direction = Vector2.ZERO
	
func enable():
	input_disabled = false

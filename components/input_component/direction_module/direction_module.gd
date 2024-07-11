extends InputModule

var joystick_direction
var previous_direction

# Called when the node enters the scene tree for the first time.
func update():
	direction = Input.get_vector("left", "right", "up", "down")
	joystick_direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	if joystick_direction:
		direction = joystick_direction
	if direction:
		previous_direction = direction

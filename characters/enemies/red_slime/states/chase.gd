extends State

@onready var steering = get_node("SteeringComponent")

func Enter():
	print('entering chase')
	steering.process_mode = PROCESS_MODE_INHERIT
	animation.play(self.name)
	#animation.set_direction(self.name, steering.direction)
	
func Exit():
	print('leaving chase')
	steering.process_mode = PROCESS_MODE_DISABLED
	
func Update(_delta:float):
	if is_nan(steering.direction.x):
		push_warning('Steering calculation is return Vector2(NAN,NAN)')
		return
	#steering.parse_steering_direction(self)
	animation.set_direction(self.name, steering.direction)
	state_movement()
	
func state_movement():
	var target_direction = steering.direction
	if target_direction == Vector2.ZERO:
		state_transition.emit(self, 'idle')
	else:
		owner.velocity.x = target_direction.x * steering.chase_speed
		owner.velocity.y = target_direction.y * steering.chase_speed

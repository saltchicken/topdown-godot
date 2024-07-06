extends State

@onready var steering = get_node("SteeringComponent")

func Enter():
	steering.process_mode = PROCESS_MODE_INHERIT
	animation.play(self.name)
	animation.set_direction(self.name, steering.idle_direction)
	
func Exit():
	steering.process_mode = PROCESS_MODE_DISABLED
	
func Update(_delta:float):
	state_movement()
	
func state_movement():
	var target_direction = steering.direction
	if target_direction != null:
		if !is_nan(target_direction.x) and target_direction != Vector2.ZERO:
			state_transition.emit(self, 'chase')
		else:
			owner.velocity = Vector2(0.0, 0.0)

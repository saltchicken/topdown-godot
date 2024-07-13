extends State

func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, input.previous_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	input.parse_input_action()
	if input.direction:
		owner.moving.emit()
	
	animation.set_direction(self.name, input.previous_direction)
	state_movement()
	
func state_movement():
	#owner.velocity.x = move_toward(owner.velocity.x, 0, DECELERATION_SPEED)
	#owner.velocity.y = move_toward(owner.velocity.y, 0, DECELERATION_SPEED)
	owner.velocity = Vector2(0.0, 0.0)

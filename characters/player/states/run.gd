extends State

func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, input.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	input.parse_input_action()
	animation.set_direction(self.name, input.direction)
	
	if !input.direction:
		owner.idle.emit()
		
	state_movement()
		
func state_movement():
	owner.velocity.x = input.direction.x * owner.run_speed
	owner.velocity.y = input.direction.y * owner.run_speed

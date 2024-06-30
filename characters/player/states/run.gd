extends State

func Enter():
	#print('entering run')
	animation.play(self.name)
	animation.set_direction(self.name, input.direction)
	
func Exit():
	pass
	
func Update(delta:float):
	#print('updating run')
	input.parse_input_action(self)
	input.parse_input_direction(self)
	animation.set_direction(self.name, input.direction)
		
func state_movement():
	owner.velocity.x = input.direction.x * owner.run_speed
	owner.velocity.y = input.direction.y * owner.run_speed

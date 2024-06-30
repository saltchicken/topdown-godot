extends State

func Enter():
	#print('entering run')
	animation.play(self.name)
	animation.set_direction(self.name, input.direction)
	
func Exit():
	pass
	
func Update(delta:float):
	#print('updating run')
	parse_input_direction(self)
	animation.set_direction(self.name, input.direction)
		
func state_movement():
	character_body.velocity.x = input.direction.x * character_body.run_speed
	character_body.velocity.y = input.direction.y * character_body.run_speed

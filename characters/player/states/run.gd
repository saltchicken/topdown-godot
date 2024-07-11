extends State

var previous_direction

func Enter():
	#print('entering run')
	input.update()
	animation.play(self.name)
	animation.set_direction(self.name, input.direction)
	
func Exit():
	pass
	
func Update(delta:float):
	#print('updating run')
	#input.parse_input_action(self)
	#input.parse_input_direction(self)
	#animation.set_direction(self.name, input.direction)
	
	input.update()
	if input.direction.is_equal_approx(Vector2.ZERO):
		owner.idle.emit(previous_direction)
		return
	if input.attack:
		owner.attack.emit(input.direction)
		return
	animation.set_direction(self.name, input.direction)
	state_movement()
	previous_direction = input.direction
		
func state_movement():
	owner.velocity.x = input.direction.x * owner.run_speed
	owner.velocity.y = input.direction.y * owner.run_speed

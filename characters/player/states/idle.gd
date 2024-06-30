extends State

func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, input.previous_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	parse_input_direction()
	
	animation.set_direction(self.name, input.previous_direction)
	
func state_movement():
	#character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	#character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	character_body.velocity = Vector2(0.0, 0.0)

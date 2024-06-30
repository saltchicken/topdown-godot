extends State

func Enter():
	#print("entering idle")
	animation.play(self.name)
	animation.set_direction(self.name, input.previous_direction)
	
func Exit():
	pass
	
func Update(delta:float):
	#print("updating idle")
	parse_input_direction(self)
	parse_input_action(self)
	
	animation.set_direction(self.name, input.previous_direction)
	
func state_movement():
	#character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	#character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	character_body.velocity = Vector2(0.0, 0.0)

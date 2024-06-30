extends State


func Enter():
	print('Entering idle')
	animation.play(self.name)
	animation.set_direction(self.name, steering.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	steering.parse_steering_direction(self)
	state_movement()
	
func state_movement():
	print('hello')
	owner.velocity = Vector2(0.0, 0.0)

extends State


func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, steering.idle_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	steering.parse_steering_direction(self)
	state_movement()
	
func state_movement():
	owner.velocity = Vector2(0.0, 0.0)
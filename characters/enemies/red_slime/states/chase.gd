extends State


func Enter():
	steering.update()
	animation.play(self.name)
	animation.set_direction(self.name, steering.direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	steering.update()
	if steering.direction.is_equal_approx(Vector2.ZERO):
		owner.idle.emit()
		return
	#steering.parse_steering_direction(self)
	animation.set_direction(self.name, steering.direction)
	state_movement()
	
func state_movement():
	var target_direction = steering.direction
	owner.velocity.x = target_direction.x * steering.chase_speed
	owner.velocity.y = target_direction.y * steering.chase_speed

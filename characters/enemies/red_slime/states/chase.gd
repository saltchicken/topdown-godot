extends State


func Enter():
	steering.init()
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
	animation.set_direction(self.name, steering.direction)
	state_movement()
	
func state_movement():
	owner.velocity.x = steering.direction.x * steering.chase_speed
	owner.velocity.y = steering.direction.y * steering.chase_speed

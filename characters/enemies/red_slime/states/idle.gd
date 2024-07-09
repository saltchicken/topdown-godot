extends State


func Enter():
	steering.update()
	print(steering.direction)
	animation.play(self.name)
	animation.set_direction(self.name, steering.idle_direction)
	
func Exit():
	steering.direction = Vector2.ZERO # TODO: Why is this necessary
	pass
	
func Update(_delta:float):
	steering.update()
	if steering.direction != Vector2.ZERO:
		print('moving')
		owner.moving.emit()
		return
	#steering.parse_steering_direction(self)
	state_movement()
	
func state_movement():
	owner.velocity = Vector2(0.0, 0.0)

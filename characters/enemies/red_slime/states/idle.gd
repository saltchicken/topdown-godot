extends State


func Enter():
	print('Entering Idle')
	steering.update()
	animation.play(self.name)
	animation.set_direction(self.name, steering.idle_direction)
	
func Exit():
	steering.direction = Vector2.ZERO # TODO: Why is this necessary
	var raycast = steering.behaviors[0]
	raycast.target_position = null
	print(raycast)
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

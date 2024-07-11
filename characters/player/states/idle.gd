extends State

var idle_direction

func Enter(direction = null):
	animation.play(self.name)
	if direction != null:
		idle_direction = direction
	else:
		idle_direction = Vector2(0,-1)
	animation.set_direction(self.name, idle_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	input.update()
	if input.direction != Vector2.ZERO:
		owner.moving.emit()
		return
	if input.attack:
		owner.attack.emit(idle_direction)
		return
	state_movement()

	
	#
	#animation.set_direction(self.name, input.previous_direction)
	
func state_movement():
	#owner.velocity.x = move_toward(owner.velocity.x, 0, DECELERATION_SPEED)
	#owner.velocity.y = move_toward(owner.velocity.y, 0, DECELERATION_SPEED)
	owner.velocity = Vector2(0.0, 0.0)

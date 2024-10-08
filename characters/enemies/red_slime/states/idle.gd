extends State

@export var idle_direction : Vector2 = Vector2(0.0, 1.0)

func Enter():
	steering.init()
	animation.play(self.name)
	animation.set_direction(self.name, idle_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	steering.update()
	if steering.direction != Vector2.ZERO:
		owner.moving.emit()
		return
	state_movement()
	
func state_movement():
	owner.velocity = Vector2(0.0, 0.0)

extends State

@onready var steering = get_node("SteeringComponent")

func Enter():
	steering.process_mode = PROCESS_MODE_INHERIT
	animation.play(self.name)
	animation.set_direction(self.name, steering.direction)
	
func Exit():
	steering.process_mode = PROCESS_MODE_DISABLED
	
func Update(_delta:float):
	state_movement()
	
func state_movement():
	owner.velocity = Vector2(0.0, 0.0) # TODO: This is essentially idle. Add random movement or desired wander

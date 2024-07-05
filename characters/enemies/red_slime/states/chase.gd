extends State


func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, steering.direction_to_player)
	
func Exit():
	pass
	
func Update(_delta:float):
	steering.parse_steering_direction(self)
	animation.set_direction(self.name, steering.direction_to_player)
	state_movement()
	
func state_movement():
	var target_direction = steering.final_velocity
	owner.velocity.x = target_direction.x * steering.chase_speed
	owner.velocity.y = target_direction.y * steering.chase_speed

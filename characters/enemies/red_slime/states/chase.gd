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
	owner.velocity.x = steering.direction_to_player.x * steering.chase_speed
	owner.velocity.y = steering.direction_to_player.y * steering.chase_speed

extends State

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation.play(self.name)
	animation.set_direction(self.name, input.previous_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	state_movement()
	pass
	#print('updating run')
	#parse_input_direction(self)
	#animation.set_direction(self.name, input.direction)
		
func state_movement():
	owner.velocity = Vector2(0.0, 0.0)
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		input.parse_input_direction(self)
	

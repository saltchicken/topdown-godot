extends State

var attack_direction

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter(direction):
	animation.play(self.name)
	attack_direction = direction
	animation.set_direction(self.name, attack_direction)
	
func Exit():
	pass
	
func Update(delta:float):
	state_movement()
	pass
	#print('updating run')
	#parse_input_direction(self)
	#animation.set_direction(self.name, input.direction)
		
func state_movement():
	owner.velocity = Vector2(0.0, 0.0)
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		owner.idle.emit(attack_direction)
	

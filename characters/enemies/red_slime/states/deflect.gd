extends State

var deflect_direction
@export var deflect_velocity = 50

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter(direction):
	print("Entering deflect")
	deflect_direction = direction
	animation.play(self.name)
	animation.set_direction(self.name, deflect_direction)
	
func Exit():
	pass
	
func Update(_delta:float):
	state_movement()
	
func state_movement():
	owner.velocity = deflect_direction * deflect_velocity
	
func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name.split('/')[0] == self.name:
		owner.idle.emit()

extends State

@export var dash_speed: float = 250.0
var dash_direction

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation.play(self.name)
	dash_direction = input.previous_direction
	animation.set_direction(self.name, dash_direction)
	owner.set_collision_layer_value(1, false)
	owner.set_collision_mask_value(1, false)
	owner.set_collision_mask_value(2, false)
	owner.set_collision_mask_value(3, false)
	
func Update(_delta:float):
	state_movement()
	
func Exit():
	owner.set_collision_layer_value(1, true)
	owner.set_collision_mask_value(1, true)
	owner.set_collision_mask_value(2, true)
	owner.set_collision_mask_value(3, true)
	
func state_movement():
	owner.velocity = dash_direction * dash_speed

func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		owner.idle.emit()
		

extends State

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter(attack: Attack):
	animation.play(self.name)
	owner.velocity = -owner.global_position.direction_to(attack.attacker.global_position) * 50 # This needs to be knockback
	##animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Update(_delta:float):
	state_movement()
	
func state_movement():
	# Apply deceleration
	owner.velocity.x = move_toward(owner.velocity.x, 0, 1.5)
	owner.velocity.y = move_toward(owner.velocity.y, 0, 1.5)
	
func i_frames_handler():
	var health_component = owner.get_node('HealthComponent')
	if health_component:
		health_component.i_frames = 0.5

func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		i_frames_handler()
		state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle

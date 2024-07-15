extends State

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter(attack: Attack):
	animation.play(self.name)
	owner.velocity = -owner.global_position.direction_to(attack.attacker.global_position) * 50 # This needs to be knockback
	##animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Update(_delta:float):
	if owner.collision:
		var collision_body = owner.collision.get_collider()
		if collision_body.state_machine.current_state.name != 'deflect' and collision_body is CharacterBody2D: # TODO: Make sure the the collision body is able to accept a deflect
			collision_body.deflect.emit(owner.velocity.normalized())
	state_movement()
	
func state_movement():
	# Apply deceleration
	owner.velocity.x = move_toward(owner.velocity.x, 0, 1.5)
	owner.velocity.y = move_toward(owner.velocity.y, 0, 1.5)
	
func i_frames_handler():
	var health_component = owner.get_node('HealthComponent')
	if health_component:
		health_component.i_frames = owner.i_frames

func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		i_frames_handler()
		state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle

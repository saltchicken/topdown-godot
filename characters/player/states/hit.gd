extends State

func _ready():
	animation.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	print('Entering hit')
	animation.play(self.name)
	

#func Enter(params: Dictionary = {}):
	#if params.has('attacking_body'):
		#if take_damage_check_death(character_body, params['attacking_body']):
			#state_transition.emit(character_body.state_machine.current_state, 'death')
			#return
		#else:
			#animation_tree.get("parameters/playback").start(self.name)
			##animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
			#var knockback = params['attacking_body'].stats.attack_knockback
			#character_body.velocity = -character_body.direction_to_player * (knockback / character_body.stats.knockback_protection)
	#else:
		#print("Hit shouldn't be called without an attacking body")
	#
#func Exit():
	#pass
	#
func Update(_delta:float):
	state_movement()
	
func state_movement():
	owner.velocity = Vector2.ZERO
	#owner.velocity = -steering.direction_to_player * 50 # (knockback / character_body.stats.knockback_protection)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name.split('/')[0] == self.name:
		var health_component = owner.get_node('HealthComponent')
		if health_component:
			health_component.i_frames = 0.5
		state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle

extends Node2D

@export var attack_damage := 20
@export var attack_type : Constants.AttackType = Constants.AttackType.CONTACT

func _physics_process(_delta: float) -> void:
	if owner.collision:
		var body = owner.collision.get_collider()
		if body is Player:
			var attack = Attack.new()
			attack.attacker = owner
			attack.attack_damage = attack_damage
			attack.attack = self
			body.get_node('HealthComponent').damage(attack)
				#self.state_machine.current_state.state_transition.emit(self.state_machine.current_state, 'collision_attack')
		#elif body.get_script() == Enemy:
			#if self.state_machine.current_state.name == 'hit' or (abs(self.impact_velocity.x) > 0.0 and abs(self.impact_velocity.y) > 0.0):
				#body.handle_impact_with_enemy(self)

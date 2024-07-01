class_name HealthComponent extends Node2D

@export var MAX_HEALTH := 100.0
@export var state_machine: FiniteStateMachine
var health : float

#signal hit
#signal death

func _ready():
	health = MAX_HEALTH
	
func damage(attack: Attack):
	if health <= 0:
		push_warning("Should be dead already")
	if state_machine:
		if state_machine.current_state.name not in ["hit", "death"]:
			health -= attack.attack_damage
			if health <= 0:
				print('set to death')
				state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
			else:
				state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
	else:
		push_warning("StateMachine not set")
	
			

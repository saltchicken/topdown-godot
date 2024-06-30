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
	health -= attack.attack_damage
	if state_machine:
		print('setting to hit')
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
	
	if health <= 0:
		print("Death should be handled")
		if state_machine:
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')

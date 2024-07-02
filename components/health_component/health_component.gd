class_name HealthComponent extends Node2D

@export var MAX_HEALTH := 100.0
@export var state_machine: FiniteStateMachine
var health : float

var i_frames = 0.0

#signal hit
#signal death

func _ready():
	health = MAX_HEALTH
	
func _physics_process(delta: float) -> void:
	i_frame_handler(delta)

func i_frame_handler(delta):
	i_frames -= delta
	if i_frames < 0.0:
		i_frames = 0.0

func damage(attack: Attack):
	if health <= 0:
		push_warning("Should be dead already")
	if state_machine:
		if state_machine.current_state.name not in ["hit", "death"] and i_frames <= 0.0:
			health -= attack.attack_damage
			if health <= 0:
				print('set to death')
				state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
			else:
				state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', attack)
	else:
		push_warning("StateMachine not set")
	
			

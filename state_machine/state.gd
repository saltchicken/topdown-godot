extends Node
class_name State

@onready var character_body = self.get_owner()
@onready var input: InputComponent = get_parent().input
@onready var animation: AnimationTree = get_parent().animation

@warning_ignore("unused_signal")
signal state_transition

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func state_movement():
	pass
	
func parse_input_direction() -> void:
	if input.direction:
		state_transition.emit(self, 'run')
	else:
		state_transition.emit(self, 'idle')
	state_movement()


# TODO: This goes to health component	
#func take_damage_check_death(receiving_body, attacking_body):
	#var damage = attacking_body.stats.attack_damage
	#SceneManager.hit_indicator(self, str(damage), receiving_body.hit_indicator_offset.x, receiving_body.hit_indicator_offset.y)
	#receiving_body.stats.health -= damage
	#if receiving_body.stats.health <= 0:
		#receiving_body.stats.health = 0
		#return true
	#else:
		#return false

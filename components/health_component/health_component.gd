class_name HealthComponent extends Node2D

@export var MAX_HEALTH := 100.0
@export var state_machine: FiniteStateMachine
var health : float

var i_frames = 0.0

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
		return
	if state_machine:
		if state_machine.current_state.name not in ["hit", "death"] and i_frames <= 0.0:
			health -= attack.attack_damage
			if health <= 0:
				print('set to death')
				#state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
				owner.death.emit()
				if attack.attacker is Player:
					attack.attacker.profile.experience += owner.experience
			else:
				hit_indicator(owner, str(attack.attack_damage))
				owner.hit.emit(attack)
	else:
		push_warning("StateMachine not set")


var hit_indicator_node = preload("res://text/hit_indicator/hit_indicator.tscn")

func hit_indicator(parent_node, text_info: String, x_offset: float = 0.0, y_offset: float = 10.0):
	var hit_indicator_instance = hit_indicator_node.instantiate()
	parent_node.add_child(hit_indicator_instance)
	hit_indicator_instance.set_text(text_info)
	hit_indicator_instance.x_offset = x_offset
	hit_indicator_instance.y_offset = y_offset
	hit_indicator_instance.main()

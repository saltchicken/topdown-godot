extends StaticBody2D
class_name Chest

@export var item: ItemData
@onready var item_taken = false
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

signal interact


func _ready():
	interact.connect(on_interact)

func on_interact():
	print("interacting with chest")
	open_chest()
	
func open_chest():
	if state_machine.current_state.name == 'closed':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'opening')
		
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"current_state" : state_machine.current_state.name,
		#"item" : item.get_path(), # TODO: Do we want to save the item in the chest? If there is no item this crashes save (null object and all that)
		"item_taken" : item_taken
	}
	return save_dict

		
		
#func save():
	#var save_dict = {
		#"filename" : get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		#"pos_x" : position.x,
		#"pos_y" : position.y,
		#"current_state" : state_machine.current_state.name,
		#"item" : item.get_path(),
		#"item_taken" : item_taken
	#}
	#return save_dict

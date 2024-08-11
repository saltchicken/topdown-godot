extends StaticBody2D
class_name Chest

@onready var item: InventoryItem
@onready var item_taken = false
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

signal interact

signal chest_opened


func _ready():
	# TODO: This whole getting children of the chest needs to be cleaned up
	var items = find_children('*', "InventoryItem", true, false)
	if items.size() > 1:
		push_error("More than one item in chest has not been implemented yet")
	elif items.size() == 1:
		item = items[0]
	else:
		push_warning("No items in this chest")
	
	if item != null:
		_disable_item(item)
		#item.global_position += Vector2(-16.0, 32.0) # TODO: This places the item behind the chest but its not really needed

	
	interact.connect(on_interact)

func on_interact(interactor):
	if state_machine.current_state.name == 'closed':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'opening')
	await chest_opened
	if item and !item_taken:
		Global.dialogue_panel(self, ["You received a %s" %item.item_name])
		if interactor.has_signal("collect"):
			remove_child(item)
			_enable_item(item)
			interactor.collect.emit(item)
			item_taken = true
		else:
			push_error("Interactor does not have collect signal")
		#character_body.player.inventory.collect_item(character_body.item.resource_path)
		#character_body.item_taken = true
	else:
		print('no item')
		
func _disable_item(item):
	item.process_mode = Node.PROCESS_MODE_DISABLED
	item.visible = false
	
func _enable_item(item):
	item.process_mode = Node.PROCESS_MODE_INHERIT
	item.visible = true
		
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"name" : name,
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

extends Node2D

@onready var item_to_drop
@onready var drops = get_children() # TODO: Validate these drops

func _ready() -> void:
	for drop in drops:
		_disable_item(drop)

func drop_items():
	for drop in drops:
		_drop(drop)
	
func _drop(item):
	remove_child(item)
	item.global_position = global_position
	if item is InventoryItem:
		item.size = Vector2(32.0, 32.0) # TODO: Better handling of size forcing
	_enable_item(item) 
	get_tree().current_scene.get_node("LevelHolder").get_children()[0].add_child(item) # TODO: Replace this with a call to Global
	
	
func _disable_item(item):
	item.process_mode = Node.PROCESS_MODE_DISABLED
	item.visible = false
	
func _enable_item(item):
	item.process_mode = Node.PROCESS_MODE_INHERIT
	item.visible = true

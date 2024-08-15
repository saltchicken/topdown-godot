extends Node2D

@onready var item_to_drop
@onready var drops = get_children() # TODO: Validate these drops

@onready var dropper_node = preload("res://items/components/drop/dropper/dropper.tscn")

func _ready() -> void:
	for drop in drops:
		_disable_item(drop)

func drop_items():
	for drop in drops:
		_drop(drop)
		#await get_tree().create_timer(0.01).timeout
	
func _drop(item):
	remove_child(item)
	var dropper = dropper_node.instantiate()
	dropper.global_position = global_position #  + Vector2(randf() * 4, randf() * 4)
	item.position = Vector2(0.0,0.0)
	dropper.item_to_drop = item
	dropper.get_node("Item").add_child(item)
	if item is InventoryItem:
		item.size = Vector2(32.0, 32.0) # TODO: Better handling of size forcing
		item.position += Vector2(-16.0, -16.0)
	#_enable_item(item) 
	item.visible = true
	get_tree().current_scene.get_node("LevelHolder").get_children()[0].add_child(dropper) # TODO: Replace this with a call to Global
	dropper.velocity = Vector2(0.0, 200.0).rotated(randf_range(-1.5, 1.5))  * randf_range(0.9, 1.5)
	#dropper.velocity = owner.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
	
	
	
func _disable_item(item):
	item.process_mode = Node.PROCESS_MODE_DISABLED
	item.visible = false
	
func _enable_item(item):
	item.process_mode = Node.PROCESS_MODE_INHERIT
	item.visible = true

extends Node2D

@onready var item_to_drop
@onready var drops = get_children() # TODO: Validate these drops

@onready var dropper_node = preload("res://items/components/drop/dropper/dropper.tscn")

var rng = RandomNumberGenerator.new()
@export var probability_array: Array[int]

func _ready() -> void:
	for drop in drops:
		_disable_item(drop)
		
	# NOTE: The following block makes sure probability array matches the amount of drops or else defaults to always drop.
	if probability_array.size() != drops.size():
		push_error("Probability Array incorrectly set for ", self.name, "Setting default of always drop drops")
		probability_array = []
		for i in drops.size():
			probability_array.append(100)

func drop_items():
	for i in drops.size():
		var chance = rng.randi_range(1,100)
		if probability_array[i] >= chance:
			_drop(drops[i])
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
	call_deferred("attach_dropper_to_current_scene", dropper)
	if owner is StaticBody2D:
		dropper.velocity = Vector2(0.0, 100.0).rotated(randf_range(-1.5, 1.5))  * randf_range(0.9, 1.5)
	elif owner is CharacterBody2D:
		dropper.velocity = owner.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
	else:
		push_error("This owner type hasn't been accounted for ", owner, " defaulted to StaticBody2D response")
		dropper.velocity = Vector2(0.0, 100.0).rotated(randf_range(-1.5, 1.5))  * randf_range(0.9, 1.5)
	

func attach_dropper_to_current_scene(dropper):
	get_tree().current_scene.get_node("LevelHolder").get_children()[0].add_child(dropper) # TODO: Replace this with a call to Global
	
func _disable_item(item):
	item.process_mode = Node.PROCESS_MODE_DISABLED
	item.visible = false
	
func _enable_item(item):
	item.process_mode = Node.PROCESS_MODE_INHERIT
	item.visible = true

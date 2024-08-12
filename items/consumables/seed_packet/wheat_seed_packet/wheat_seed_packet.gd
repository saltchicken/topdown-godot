extends SeedPacket

@onready var place_component = get_node("Place")

func use(player, item_slot):
	var result = place_component.place(player)
	if result == true:
		consume_item(item_slot)
	else:
		print("Unable to place here")
	
	#var health_component = player.get_node_or_null("HealthComponent")
	#if health_component != null:
		#health_component.add_health(amount)
		#consume_item(item_slot)
	#else:
		#push_error("Target of item use does not have a HealthComponent")

func consume_item(item_slot):
	var item = item_slot.get_item()
	if item.stack_count > 1:
		item.stack_count -= 1
	elif item.stack_count == 1:
		item_slot.remove_child(item)
		item.queue_free()
	else:
		push_error("Stack count should not be 0 or lower. Item stack count is ", item.stack_count)

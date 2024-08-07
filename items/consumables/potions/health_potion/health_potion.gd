extends Potion

#@export_enum("HEALTH", "MANA") var potion_type


func use(player, item_slot):
	var health_component = player.get_node_or_null("HealthComponent")
	if health_component != null:
		health_component.add_health(amount)
		consume_item(item_slot)
	else:
		push_error("Target of item use does not have a HealthComponent")

func consume_item(item_slot):
	var item_stack = item_slot.get_children()[0]
	# TODO: Add functionality for consuming only one if there is a stack. Right now it just uses the whole thing.
	item_slot.remove_child(item_stack)
	item_stack.queue_free()
	

extends Potion

func use(player, item_slot):
	var health_component = player.get_node_or_null("HealthComponent")
	if health_component != null:
		health_component.add_health(amount)
		consume_item(item_slot)
	else:
		push_error("Target of item use does not have a HealthComponent")
	

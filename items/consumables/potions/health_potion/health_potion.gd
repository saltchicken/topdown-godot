extends ItemData

#@export_enum("HEALTH", "MANA") var potion_type


func use(player):
	var health_component = player.get_node_or_null("HealthComponent")
	if health_component != null:
		health_component.add_health(attack_damage) # TODO: Do not use attack_damage. ItemData needs to be rewritten with a variable for universal magnituded
	else:
		push_error("Target of item use does not have a HealthComponent")

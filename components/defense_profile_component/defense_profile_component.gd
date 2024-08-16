extends Node2D

@onready var defenses = get_children()

func apply(attack: Attack):
	var damage = attack.attack_damage
	var modifier_total = 0.0
	match attack.attack.attack_type:
		Constants.AttackType.WEAPON:
			for defense in defenses:
				if attack.attack.weapon_type == defense.weapon:	
					if defense.defense_type == 1:
						modifier_total -= defense.modifier
					elif defense.defense_type == 0:
						modifier_total += defense.modifier
					else:
						push_error("Unsupported enum in defense_type")
		Constants.AttackType.SPELL:
			for defense in defenses:
				if attack.attack.element == defense.spell:
					if defense.defense_type == 1:
						modifier_total -= defense.modifier
					elif defense.defense_type == 0:
						modifier_total += defense.modifier
					else:
						push_error("Unsupported enum in defense_type")
		Constants.AttackType.CONTACT:
			print("Contact made")
			
	print("Modifier Total: ", modifier_total)
	var damage_modifier = (100.0 - modifier_total) / 100.0
	print("Damage Modifier ", damage_modifier)
	if damage_modifier <= 0.0: # TODO: Add this check to damage in HealthComponent to make sure that negative damage does not heal
		damage_modifier = 0.0
	damage *= damage_modifier
	damage = round(damage)
	return damage

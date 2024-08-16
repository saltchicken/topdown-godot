extends Node2D

@onready var resistances = get_children()

func apply(attack: Attack):
	var damage = attack.attack_damage
	var damage_reduction_total = 0.0
	match attack.attack.attack_type:
		Constants.AttackType.WEAPON:
			for resistance in resistances:
				print(attack.attack.weapon_type)
				print(resistance.weapon_resistance)
				if attack.attack.weapon_type == resistance.weapon_resistance:
					damage_reduction_total += resistance.damage_reduction
			#match attack.attack.weapon_type:
				#Constants.WeaponType.SWORD:
					#print("Sword was used")
		Constants.AttackType.SPELL:
			print("Spell was used")
		Constants.AttackType.CONTACT:
			print("Contact made")
			
	print(damage_reduction_total)
	var protection = 1.0 - (damage_reduction_total / 100.0)
	print("Protection ", protection)
	if protection <= 0.0:
		protection = 0.0
	damage *= protection
	damage = round(damage)
	return damage

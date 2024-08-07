extends Node2D

func _ready():
	self.area_entered.connect(_on_hitbox_area_entered)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent and area.owner != owner:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attacker = owner
		attack.attack_damage = owner.current_weapon.attack_damage
		
		hitbox.damage(attack)

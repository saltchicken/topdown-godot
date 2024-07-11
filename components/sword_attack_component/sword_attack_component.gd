extends Node2D

var attack_damage := 35.0

func _ready():
	self.area_entered.connect(_on_hitbox_area_entered)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent and area.owner != owner:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attacker = owner
		attack.attack_damage = attack_damage
		
		hitbox.damage(attack)

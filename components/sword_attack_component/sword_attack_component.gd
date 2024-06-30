extends Node2D

var attack_damage := 10.0

func _ready():
	self.area_entered.connect(_on_hitbox_area_entered)

func _on_hitbox_area_entered(area):
	if area is HitboxComponent and area.owner != owner:
		print('Hitbox hit')
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		
		hitbox.damage(attack)

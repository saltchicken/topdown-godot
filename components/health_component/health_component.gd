class_name HealthComponent extends Node2D

@export var MAX_HEALTH := 100.0
var health : float

func _ready():
	health = MAX_HEALTH
	
func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		print("Death should be handled")

class_name HitboxComponent extends Area2D

@export var health_component : HealthComponent

func damage(attack: Attack):
	print('hit')
	if health_component:
		health_component.damage(attack)

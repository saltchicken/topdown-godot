class_name Weapon
extends Equipment

enum attackType {NULL, SWORD, BOW}

@export var attack_type: attackType = attackType.NULL
@export var attack_damage: int = 0

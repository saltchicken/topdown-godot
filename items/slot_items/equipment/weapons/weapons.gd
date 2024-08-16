class_name Weapon
extends Equipment

@onready var attack_type: Constants.AttackType = Constants.AttackType.WEAPON
@export var weapon_type: Constants.WeaponType = Constants.WeaponType.NULL
@export var attack_damage: int = 0

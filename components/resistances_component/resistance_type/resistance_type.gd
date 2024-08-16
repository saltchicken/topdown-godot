extends Node2D
@export var resistance: Constants.AttackType = Constants.AttackType.NULL
@export var weapon_resistance: Constants.WeaponType = Constants.WeaponType.NULL
@export var spell_resistance: Constants.SpellType = Constants.SpellType.NULL
@export var contact_resistance: Constants.ContactType = Constants.ContactType.NULL

@export var damage_reduction: float = 0.0

func _ready() -> void:
	if resistance == null:
		push_error("Resistance not set. Experiment with destroying this node")

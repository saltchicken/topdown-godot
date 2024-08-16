extends Node2D
@export_enum("Resistance", "Weakness") var defense_type
@export var attack_type: Constants.AttackType = Constants.AttackType.NULL
@export var weapon: Constants.WeaponType = Constants.WeaponType.NULL
@export var spell: Constants.SpellType = Constants.SpellType.NULL
@export var contact: Constants.ContactType = Constants.ContactType.NULL

@export var modifier: float = 0.0

func _ready() -> void:
	if defense_type == null or attack_type == null:
		push_error("Resistance not set. Experiment with destroying this node")

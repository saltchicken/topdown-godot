class_name ItemData
extends Resource

enum Type {HEAD, CHEST, LEGS, FEET, WEAPON, ACCESSORY, MAIN}
enum AttackType {NULL, SWORD, BOW}

@export var type: Type
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var attack_type: AttackType = AttackType.NULL

@export var attack_damage: int
@export var defense: int
@export var speed_modifier: float = 1.0
@export var dash_modifier: float = 1.0

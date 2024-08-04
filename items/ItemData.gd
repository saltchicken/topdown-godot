extends Node2D
class_name ItemData

enum Type {HEAD, CHEST, WAIST, LEGS, FEET, WEAPON, NECK, MAIN}
enum attackType {NULL, SWORD, BOW}

@export var type: Type
@export var item_name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var attack_type: attackType = attackType.NULL

@export var attack_damage: int
@export var defense: int
@export var speed_modifier: float = 1.0
@export var dash_modifier: float = 1.0

	

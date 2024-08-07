extends Node2D
class_name ItemData

enum Type {HEAD, CHEST, WAIST, LEGS, FEET, WEAPON, NECK, MAIN}

@export var type: Type
@export var item_name: String
@export_multiline var description: String
@export var texture: Texture2D

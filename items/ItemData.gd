extends Node2D
class_name ItemData

enum Type {HEAD, CHEST, WAIST, LEGS, FEET, WEAPON, NECK, MAIN}

signal collect

@export var type: Type
@export var item_name: String
@export_multiline var description: String
@export var stackable: bool = false

func _ready():
	collect.connect(_on_collect)
	
func _on_collect():
	print("Collect item")

class_name SpellData
extends Resource

enum Element {FIRE, WATER, EARTH, WIND, DARK, LIGHT, NEUTRAL}
enum Type {ATTACK, BUFF, HEAL, AURA}

@export var scene: String
@export var scene_script: GDScript
@export var element: Element
@export var type: Type
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var attack_damage: int
@export var cast_speed: float
@export var attack_knockback: float

@export var position_not_centered: int
@export var y_offset: float
@export var positional_offset: float

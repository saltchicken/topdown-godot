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

func cast(owner):
	var current_spell = load(resource_path.get_basename() + ".tscn").instantiate()
	current_spell.caster = owner
	owner.get_node('/root/Gameplay').current_level.add_child(current_spell) # TODO: Is there a better way to get the current level
	current_spell.position = owner.position + owner.direction * current_spell.stats.positional_offset * current_spell.stats.position_not_centered # TODO: Clean this up
	current_spell.position.y -= current_spell.stats.y_offset
	

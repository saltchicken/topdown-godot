extends Area2D
class_name SpellData

enum Element {NEUTRAL, FIRE, WATER, EARTH, WIND, ELECTRIC, DARK, LIGHT}
enum Type {ATTACK, BUFF, HEAL, AURA}

@export var element: Element
@export var type: Type
@export var spell_name: String
@export var cost: int = 30
@export_multiline var description: String
@export var texture: Texture2D
@export var attack_damage: int
@export var cast_speed: float
@export var attack_knockback: float

@export var position_not_centered: int
@export var y_offset: float
@export var positional_offset: float

func cast(owner):
	#var current_spell = load(resource_path.get_basename() + ".tscn").instantiate()
	var current_spell = load(scene_file_path).instantiate()
	current_spell.caster = owner
	owner.get_node('/root/Gameplay').current_level.add_child(current_spell) # TODO: Is there a better way to get the current level
	current_spell.position = owner.position + owner.direction * current_spell.positional_offset * current_spell.position_not_centered # TODO: Clean this up
	current_spell.position.y -= current_spell.y_offset
	

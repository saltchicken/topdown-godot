extends Area2D
class_name Spell

enum Type {ATTACK, BUFF, HEAL, AURA}
@export var attack_type: Constants.AttackType

@export var element: Constants.SpellType
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

@onready var animation_tree = $AnimationTree
var caster
#@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
@onready var timer = get_node('Timer')

@onready var cast_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_on_hitbox_area_entered)
	animation_tree.get("parameters/playback").start('casted')
	cast_direction = caster.direction
	animation_tree.set("parameters/casted/BlendSpace2D/blend_position", cast_direction)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_position(self, delta)
	
func process_position(_parent, _delta):
	pass

func _on_hitbox_area_entered(area):
	if area is HitboxComponent: # and area.owner != caster: # NOTE: This isn't needed with proper collision layer
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attacker = caster
		attack.attack_damage = attack_damage
		attack.attack = self
		
		hitbox.damage(attack)


func _on_timer_timeout() -> void:
	queue_free()
	
func cast(owner):
	#var current_spell = load(resource_path.get_basename() + ".tscn").instantiate()
	var current_spell = load(scene_file_path).instantiate()
	current_spell.caster = owner
	owner.get_node('/root/Gameplay').current_level.add_child(current_spell) # TODO: Is there a better way to get the current level
	current_spell.position = owner.position + owner.direction * current_spell.positional_offset * current_spell.position_not_centered # TODO: Clean this up
	current_spell.position.y -= current_spell.y_offset

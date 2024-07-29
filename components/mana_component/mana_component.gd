class_name ManaComponent extends Node2D

@export var MAX_MANA := 200.0
#@export var state_machine: FiniteStateMachine
var mana : float : set = _set_mana

signal mana_update

func _set_mana(new_value):
	mana = new_value
	mana_update.emit()
	

var i_frames = 0.0

func _ready():
	mana = MAX_MANA
	
func spend_mana(cost):
	mana -= cost



#var hit_indicator_node = preload("res://text/hit_indicator/hit_indicator.tscn")
#
#func hit_indicator(parent_node, text_info: String, x_offset: float = 0.0, y_offset: float = 10.0):
	#var hit_indicator_instance = hit_indicator_node.instantiate()
	#parent_node.add_child(hit_indicator_instance)
	#hit_indicator_instance.set_text(text_info)
	#hit_indicator_instance.x_offset = x_offset
	#hit_indicator_instance.y_offset = y_offset
	#hit_indicator_instance.main()

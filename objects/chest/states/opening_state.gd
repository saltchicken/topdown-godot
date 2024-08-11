extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == self.name:
		character_body.chest_opened.emit()
		state_transition.emit(self, 'open')

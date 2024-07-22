extends Sprite2D

#@onready var up_tween = create_tween()
#@onready var down_tween = create_tween()

@onready var tween = create_tween()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.set_loops()
	up_down()


func up_down():
	tween.tween_property(self, "position", position + Vector2(0.0, -40.0), 3).set_trans(Tween.TRANS_QUAD)#.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + Vector2(0.0, 40.0), 3).set_trans(Tween.TRANS_QUAD) #.set_ease(Tween.EASE_OUT)
	
	
	
